/**
 * Copyright(C) 2019 Rokae Technology Co., Ltd.
 * All Rights Reserved.
 *
 * Information in this file is the intellectual property of Rokae Technology
 * Co., Ltd, And may contains trade secrets that must be stored and viewed
 * confidentially.
 */

/**
 * 基于傅里叶级数的关节空间激励轨迹
 */

#include <cmath>
#include <iostream>
#include <functional>
#include <fstream>
#include <vector>
#include <array>
#include <iomanip>
#include <cstdlib>

#include <time.h>

#include <Eigen/Dense>

#include "ini.h"
#include "joint_motion.h"
#include "print_rci.h"
#include "rci_data/command_types.h"
#include "rci_data/robot_datas.h"
#include "robot.h"
#include "move.h"

// trajectory parameters
#define PI 3.1415926535
#define RAD_FREQ 0.3141592653	// 2*0.05*PI

using namespace xmate;
using JointControl = std::function<JointPositions(RCI::robot::RobotState robot_state)>;

/**
 * @brief: read coeffs from txt
 * @param[in] fileName: .txt file
 * @param[in] coeffs: coefficients for fourier-based series
 */
void readCoeffsFromFile(const std::string& fileName, Eigen::Matrix<double, 7, 11>& comat)
{
	std::ifstream outHandle;
	outHandle.open(fileName.data());
	assert(outHandle.is_open());
	
	int cnt = 0;
	std::string line_s;
	int row, column;
	
	while(getline(outHandle, line_s)){
		row = round(cnt / 11);
		column = cnt % 11;
		comat(row, column) = double(atof(line_s.c_str()));
		cnt ++;
	}
}

int main(int argc, char *argv[]) {
	// Robot initialization 
	INIParser ini;
	uint16_t port = 1337;
    std::string ipaddr = "192.168.3.41";
    std::string file = "../../xmate.ini";
    if (ini.ReadINI(file)) {
        ipaddr = ini.GetString("network", "ip");
        port = static_cast<uint16_t>(ini.GetInt("network", "port"));
    }
	
	// RCI connecting robot
    xmate::Robot robot(ipaddr, port, XmateType::XMATE3_PRO);		
    sleep(1);	// Time elapse, waiting for robot to connect
    robot.setMotorPower(1);

	// Go to home position
    std::array<double,7> q_init;
    std::array<double,7> q_drag = {{0,PI/6,0,PI/3,0,PI/2,0}};	// add scaling factor: 0.3
    q_init = robot.receiveRobotState().q;
    MOVEJ(0.2, q_init, q_drag, robot);

	// File writing handle
	std::ofstream wrtHandle;
	std::string ang_file_name = "excit_ang_record.txt";
	std::string vel_file_name = "excit_vel_record.txt";
	std::string acc_file_name = "excit_acc_record.txt";
	std::string motor_file_name = "excit_motor_record.txt";
	std::string torque_file_name = "excit_torque_record.txt";
	
	// Set controller mode and motion mode before moving
    robot.startMove(RCI::robot::StartMoveRequest::ControllerMode::kJointPosition,
                    RCI::robot::StartMoveRequest::MotionGeneratorMode::kJointPosition);

	// Control-loop var
	int vec_cnt = 0;	// counter for joint_motion_vector
	double time = 0;
	static bool init = true;
    std::array<double, 7> init_position;
    
	// Trajectory var
	double rad_t = 0;	// time for fourier series
	std::array<double, 7> q_end;
	Eigen::Matrix<double, 7, 11> coeffs;
	Eigen::Matrix<double, 11, 1> fourier;
	Eigen::Matrix<double, 7, 1> setpoint;
	readCoeffsFromFile("opt_x.txt", coeffs);
	
	std::vector<std::array<double, 7>> angVec;
	std::vector<std::array<double, 7>> velVec;
	std::vector<std::array<double, 7>> accVec;
	std::vector<std::array<double, 7>> torqueVec;
	std::vector<std::array<double, 7>> motorVec;
    
	// Control loop and callback function
	JointPositions output;
    JointControl joint_position_callback;
    joint_position_callback = [&](RCI::robot::RobotState robot_state) -> JointPositions {
		
		// initialize
        if(init == true){
            init_position = robot_state.q;
            init = false;
        }
        if(robot_state.control_command_success_rate < 0.9){
            std::cout << "通信质量较差：" << robot_state.control_command_success_rate << std::endl;
        }
		
		// record trajectory data
		angVec.push_back(robot_state.q);
		velVec.push_back(robot_state.dq_m);
		accVec.push_back(robot_state.ddq_c);
		motorVec.push_back(robot_state.motor_tau);
		torqueVec.push_back(robot_state.tau_m);
		
		// compute fourier series-based setpoints
		rad_t = RAD_FREQ * time;
		fourier << sin(rad_t * 1) / (RAD_FREQ * 1), -cos(rad_t * 1) / (RAD_FREQ * 1), 
		           sin(rad_t * 2) / (RAD_FREQ * 2), -cos(rad_t * 2) / (RAD_FREQ * 2),
				   sin(rad_t * 3) / (RAD_FREQ * 3), -cos(rad_t * 3) / (RAD_FREQ * 3), 
				   sin(rad_t * 4) / (RAD_FREQ * 4), -cos(rad_t * 4) / (RAD_FREQ * 4),
				   sin(rad_t * 5) / (RAD_FREQ * 5), -cos(rad_t * 5) / (RAD_FREQ * 5), 1;
		setpoint = coeffs * fourier;	// add scaling factor: 0.3
		q_end = {setpoint(0), setpoint(1), setpoint(2), setpoint(3), setpoint(4), setpoint(5), setpoint(6)};
		output = {{q_end[0], q_end[1], q_end[2], q_end[3], q_end[4], q_end[5], q_end[6]}};

		time += 0.001;
		if (time >= 20) {
			std::cout << "<INFO> MOTION is over." << std::endl;
			
			int file_cnt = 0;	// counter for writing lines in file
			// record joint angle data
			std::cout << "\n<INFO> OPEN" << ang_file_name << " and prepare to write joint angle ..." << std::endl;
			wrtHandle.open(ang_file_name);
			for (file_cnt = 0; file_cnt <= angVec.size() - 1; file_cnt++){
				wrtHandle << std::fixed << std::setprecision(4) << angVec[file_cnt][0] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << angVec[file_cnt][1] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << angVec[file_cnt][2] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << angVec[file_cnt][3] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << angVec[file_cnt][4] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << angVec[file_cnt][5] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << angVec[file_cnt][6] << "\n";
			}
			wrtHandle.close();
			std::cout << "<INFO> Joint angle data written, " << file_cnt+1 << "points in TOTAL." << std::endl;
			
			// record joint velocity data
			std::cout << "\n<INFO> OPEN" << vel_file_name << " and prepare to write joint velocity ..." << std::endl;
			wrtHandle.open(vel_file_name);
			for (file_cnt = 0; file_cnt <= velVec.size() - 1; file_cnt++){
				wrtHandle << std::fixed << std::setprecision(4) << velVec[file_cnt][0] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << velVec[file_cnt][1] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << velVec[file_cnt][2] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << velVec[file_cnt][3] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << velVec[file_cnt][4] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << velVec[file_cnt][5] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << velVec[file_cnt][6] << "\n";
			}
			wrtHandle.close();
			std::cout << "<INFO> Joint velocity data written, " << file_cnt+1 << "points in TOTAL." << std::endl;
			
			// record joint acceleration data
			std::cout << "\n<INFO> OPEN" << acc_file_name << " and prepare to write joint acceleration ..." << std::endl;
			wrtHandle.open(acc_file_name);
			for (file_cnt = 0; file_cnt <= accVec.size() - 1; file_cnt++){
				wrtHandle << std::fixed << std::setprecision(4) << accVec[file_cnt][0] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << accVec[file_cnt][1] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << accVec[file_cnt][2] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << accVec[file_cnt][3] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << accVec[file_cnt][4] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << accVec[file_cnt][5] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << accVec[file_cnt][6] << "\n";
			}
			wrtHandle.close();
			std::cout << "<INFO> Joint acceleration data written, " << file_cnt+1 << "points in TOTAL." << std::endl;
			
			// record force/torque (tau) data
			std::cout << "\n<INFO> OPEN " << torque_file_name << " and prepare to write force/torque ..." << std::endl;
			wrtHandle.open(torque_file_name);
			for (file_cnt = 0; file_cnt <= torqueVec.size() - 1; file_cnt++){
				wrtHandle << std::fixed << std::setprecision(4) << torqueVec[file_cnt][0] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << torqueVec[file_cnt][1] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << torqueVec[file_cnt][2] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << torqueVec[file_cnt][3] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << torqueVec[file_cnt][4] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << torqueVec[file_cnt][5] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << torqueVec[file_cnt][6] << "\n";
			}
			wrtHandle.close();
			std::cout << "<INFO> Force/Torque data written, " << file_cnt+1 << "points in TOTAL." << std::endl;
			
			// record motor torque data
			std::cout << "\n<INFO> OPEN" << motor_file_name << " and prepare to write motor torque ..." << std::endl;
			wrtHandle.open(motor_file_name);
			for (file_cnt = 0; file_cnt <= motorVec.size() - 1; file_cnt++){
				wrtHandle << std::fixed << std::setprecision(4) << motorVec[file_cnt][0] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << motorVec[file_cnt][1] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << motorVec[file_cnt][2] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << motorVec[file_cnt][3] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << motorVec[file_cnt][4] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << motorVec[file_cnt][5] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << motorVec[file_cnt][6] << "\n";
			}
			wrtHandle.close();
			std::cout << "<INFO> Motor torque data written, " << file_cnt+1 << "points in TOTAL." << std::endl;
			
			return MotionFinished(output);
		}
		
        return output;        
    };

    robot.Control(joint_position_callback);

    return 0;
}

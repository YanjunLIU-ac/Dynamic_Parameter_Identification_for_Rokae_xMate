/**
 * Copyright(C) 2019 Rokae Technology Co., Ltd.
 * All Rights Reserved.
 *
 * Information in this file is the intellectual property of Rokae Technology
 * Co., Ltd, And may contains trade secrets that must be stored and viewed
 * confidentially.
 */

/**
 * Validation trajectory based on sinusoidal function
 */


#include <cmath>
#include <iostream>
#include <functional>
#include <fstream>
#include <cstring>
#include <sstream>
#include <string>
#include <vector>
#include <array>
#include <iomanip>
#include <cstdlib>

#include <time.h>
#include <ctime> 
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>

#include <Eigen/Dense>

#include "ini.h"
#include "joint_motion.h"
#include "print_rci.h"
#include "rci_data/command_types.h"
#include "rci_data/robot_datas.h"
#include "robot.h"
#include "move.h"

#define PI 3.1415926535

using namespace xmate;
using JointControl = std::function<JointPositions(RCI::robot::RobotState robot_state)>;

/* 
 * [workspace] to save sensor data,
 * logging in chronological [folders],
 * data saved in [txt]
 */
const std::string workspace_name = "~/home/identify_val_traj/";	// TODO: target directory to save files
void log_time(std::string &s){
	time_t now = time(0);
	tm *ltm = localtime(&now);

	std::ostringstream oss;
	oss << (1900+ltm->tm_year) << "_" << (1+ltm->tm_mon) << "_" << ltm->tm_mday << "_" 
	    << (ltm->tm_hour) << "_" << (ltm->tm_min) << "_" << (ltm->tm_sec) << "/";
	s = oss.str();
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
	std::ostringstream ossp;
	std::string timestamp;
	log_time(timestamp);
	
	ossp.str("");
	ossp << workspace_name << timestamp;
	if (access(ossp.str().c_str(), 0) == -1){
		std::cout << "<WARN> Target directory not exist. Proceed mkdir..." << std::endl;
		int flag = mkdir(ossp.str().c_str(), 777);
		if (flag == 0){
			std::cout << "<INFO> mkdir succeeded." << std::endl;
		}else{
			std::cout << "<FATAL> mkdir failed!" << std::endl;
		}
	}
	
	ossp.str("");
	ossp << workspace_name << timestamp << "pos_record.txt";
	std::string ang_file_name = ossp.str();

	ossp.str("");
	ossp << workspace_name << timestamp << "vel_record.txt";
	std::string vel_file_name = ossp.str();
	
	ossp.str("");
	ossp << workspace_name << timestamp << "acc_record.txt";
	std::string acc_file_name = ossp.str();
	
	ossp.str("");
	ossp << workspace_name << timestamp << "motor_record.txt";
	std::string motor_file_name = ossp.str();
	
	ossp.str("");
	ossp << workspace_name << timestamp << "torque_record.txt";
	std::string torque_file_name = ossp.str();
	
	// Set controller mode and motion mode before moving
    robot.startMove(RCI::robot::StartMoveRequest::ControllerMode::kJointPosition,
                    RCI::robot::StartMoveRequest::MotionGeneratorMode::kJointPosition);

	// Control-loop var
	double time = 0;
	static bool init = true;
    std::array<double, 7> init_position;
	
	std::vector<std::array<double, 7>> posVec;
	std::vector<std::array<double, 7>> velVec;
	std::vector<std::array<double, 7>> accVec;
	std::vector<std::array<double, 7>> torqueVec;
	std::vector<std::array<double, 7>> motorVec;
    
	// Control loop and callback function
	JointPositions output;
    JointControl joint_position_callback;
    joint_position_callback = [&](RCI::robot::RobotState robot_state) -> JointPositions {
		time += 0.001;
		
		// initialize
        if(init == true){
            init_position = robot_state.q;
            init = false;
        }
        if(robot_state.control_command_success_rate < 0.9){
            std::cout << "通信质量较差：" << robot_state.control_command_success_rate << std::endl;
        }
		
		// record trajectory data
		posVec.push_back(robot_state.q);
		velVec.push_back(robot_state.dq_m);
		accVec.push_back(robot_state.ddq_c);
		motorVec.push_back(robot_state.motor_tau);
		torqueVec.push_back(robot_state.tau_m);
		
		// sinusoidal trajectory
		
		
		// traverse joint_motion_vector
		output = {{init_position[0], init_position[1],
				   init_position[2], init_position[3],
				   init_position[4], init_position[5],
				   init_position[6]}};
		
		// time's up
		if (time >= 20) {
			std::cout << "<INFO> MOTION is over." << std::endl;
			
			int file_cnt = 0;	// counter for writing lines in file
			// record joint angle data
			std::cout << "\n<INFO> OPEN" << ang_file_name << " and prepare to write joint angle ..." << std::endl;
			wrtHandle.open(ang_file_name);
			for (file_cnt = 0; file_cnt <= posVec.size() - 1; file_cnt++){
				wrtHandle << std::fixed << std::setprecision(4) << posVec[file_cnt][0] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << posVec[file_cnt][1] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << posVec[file_cnt][2] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << posVec[file_cnt][3] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << posVec[file_cnt][4] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << posVec[file_cnt][5] << " ";
				wrtHandle << std::fixed << std::setprecision(4) << posVec[file_cnt][6] << "\n";
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
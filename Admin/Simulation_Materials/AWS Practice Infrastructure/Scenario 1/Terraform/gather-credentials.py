import subprocess
import os
import json
import csv


##################################################
# Administrative Information
##################################################

# Used for python based installation.
os.environ['PATH'] += os.pathsep + r""


# In the case of a borked aws installation becuase of Windows installation. 
# You can choose to manually set the path to the aws executable
aws_executable_path = "C:\\Program Files\\Amazon\\AWSCLIV2\\aws.exe"

# Define the key used throughout the Terraform deployment.
AWS_Black_Team_Key=os.path.expanduser(r"AWS-CCDC-Blackteam.pem")
print("Key path: ", AWS_Black_Team_Key)


##################################################
# Usernames for the instances
# again, preexisting.
# Can separate to three if completely spinning
# up fresh instances.
##################################################
EC2_Linux_USERNAME="blueteam"
EC2_WINDOWS_USERNAME="Administrator"

##################################################
# Passwords for the instances from existing image
# with passwords already setup.
#
# Normal Linux-based instances will have
# passwords disabled so we wouldn't even need it
# You'd need to provision all that information
# through something like Ansible.
##################################################
EC2_LINUX_PASSWORD = "F}S]E5&5VtgTvsab9yCo)HcAu"
EC2_WINDOWS_PASSWORD = ".;-FbK48$xK;w2o?kh;T(ED2GdtnADiE"

#########################
# Instances List
#########################
TF_WINDOWS_INSTANCES = "Windows_Instances"
TF_LINUX_UBUNTU_INSTANCES = "Linux_Ubuntu_Instances"
TF_LINUX_RHEL_INSTANCES = "Linux_RHEL_Instances"

TF_INSTANCES_LIST = [
                        TF_WINDOWS_INSTANCES, 
                        TF_LINUX_UBUNTU_INSTANCES, 
                        TF_LINUX_RHEL_INSTANCES
                    ]

####################################
# Blackteam Pertinent Information
####################################

# Need Wireguard's public IP
TF_WIREGUARD_EIP = "Wireguard_EIP"


class DeploymentInstanceInformationGatherer:

    def get_information(self):
        """
            Summary
                Gathers information for all the instances in the deployment.
                Refer to the global variable TF_INSTANCES_LIST for the list of instances to gather information for.

            Returns:
                A list of dictionaries containing the information for each suite of instances.
        """
        informationList = []

        for suite in TF_INSTANCES_LIST:
            print("Suite: ", suite)
            suite_of_instances = self.run_terraform_output(suite)
            informationList.append(self.get_instance_suite_info(suite_of_instances))
        

        return informationList


    def get_instance_suite_info(self, suite_of_instances):
        """
            Summary:
                Will gather information for a suite of instances that are passed in.
        """
        result = {}

        if len(suite_of_instances) == 0:
            return None
        
        # Figure out the OS of the instances for the username
        os = suite_of_instances[0]['tags']['OS']
        find_password = False
        if os == "Ubuntu":
            username_to_add = EC2_Linux_USERNAME
        elif os == "Windows":
            find_password = True
            username_to_add = EC2_WINDOWS_USERNAME
        elif os == "RHEL":
            username_to_add = EC2_Linux_USERNAME


        count = 1
        password = ""
        for instance in suite_of_instances:
            
            # Find the password if it's a Windows machine.
            # Pre-made images.
            if find_password:
                password = EC2_WINDOWS_PASSWORD
            else:
                password = EC2_LINUX_PASSWORD


            # Now that we have all the pieces together, we can add the information to the result dictionary.
            result.update({
                                count:  {
                                        "Name": instance['tags']['Name'],
                                        "OS": instance['tags']['OS'],
                                        "Private-IP": instance['private_ip'],
                                        "Username": username_to_add,
                                        "Password": password
                                        }
                          })
            count += 1
        
        return result


    def run_terraform_output(self, output_name):
        """
            Summary:
                Will run the terraform output command and return the output of the command in a  json format
        """
        output = json.loads(subprocess.run(["terraform", "output", "-json", output_name], capture_output=True, text=True).stdout)
        return output



if __name__ == "__main__":
    gatherer = DeploymentInstanceInformationGatherer()
    info = gatherer.get_information()

    if info == None:
        print("[!] No information was gathered.")
        exit()
    
    csv_file = open("instance_information.csv", "w", newline="")
    csv_writer = csv.writer(csv_file)


    # Find the headers for the csv file. They'll be the keys of the inner dictionaries.
    # 0 gets the first suite of instances. 1 gets the first instance in the suite. 
    # keys() gets the keys of the dictionary of the instance. Everything is made the same.
    headers = list(info[0][1].keys()) 

    # Now, we have a list of dictionaries that contain the information for each suite of instances.
    # Let's get the information into csv file.
    
    # Write the headers to the csv file.
    csv_writer.writerow(headers)

    # Now write in the normal instance information.
    for suite in info:
        for instance in suite.values():
            csv_writer.writerow(instance.values())
        
    csv_file.close()
    
    with open('blackteam-inventory.yml', 'w') as f:
        f.write("[WireguardServer]\n")
        wireguard_server_information = gatherer.run_terraform_output(TF_WIREGUARD_EIP)
        f.write(f"{wireguard_server_information['public_ip']}" + f"\tpublic_ip={wireguard_server_information['public_ip']}") 

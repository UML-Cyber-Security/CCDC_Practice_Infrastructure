import os
import subprocess


NUM_BLUE_TEAM_CLIENTS = 8
NUM_RED_TEAM_CLIENTS = 6


def run_api_command(option:str , username:str):
    
    try:
        print(f"Will be doing \'{option}\' with arg: \'{username}\'")
        
        api_output = subprocess.run(["python3", "/home/ubuntu/wg-easy-api.py", option, username],
                                            stdout=subprocess.PIPE,
                                            stderr=subprocess.PIPE,
                                            text=False,
                                            check=True,
                                            )    
        stdout = api_output.stdout
        stderr = api_output.stderr
        
        return stdout

    except subprocess.CalledProcessError as e:
        print("Command failed with return code:", e.returncode)
        print("STDERR:", e.stderr)

def get_client_ids():
    status_dump = run_api_command("status", "NA").decode('utf-8')
    
    split_status = status_dump.splitlines()
    
    username_id_pairs = {}
    
    # First line doesn't matter atm.
    for line in split_status[1:]:
        sub_split = line.split(' ')
        print(sub_split)
        username_id_pairs[sub_split[2]] = sub_split[1]
        
    return username_id_pairs
    

def extract_cert(username_ids):
    # Ensure the 'certs' directory exists, create it if necessary
    if not os.path.exists('certs'):
        os.makedirs('certs')
    
    
    for key, value  in username_ids.items():
        print(f"Getting information for {key}")
        config = run_api_command("config", value)
        
        config = config.decode('utf-8').strip().split("'")[1]
        
        # Replace '\n' with newline characters
        config = config.replace('\\n', '\n')
        
        # Information gotten.
        with open(f'certs/{key}.conf', 'w') as f:
            f.write(config)
            f.write("\n")
        


if __name__ == "__main__":
    # Need to create a blackteam cert
    run_api_command("create", "blackteam")
    
    # Need to create all blueteam certs
    for i in range(1, NUM_BLUE_TEAM_CLIENTS+1):
        run_api_command("create", f"bt-{i}")
    
    # Need to create all redteam certs
    for i in range(1, NUM_RED_TEAM_CLIENTS+1):
        run_api_command("create", f"rt-{i}")
    
    extract_cert(get_client_ids())
    
    
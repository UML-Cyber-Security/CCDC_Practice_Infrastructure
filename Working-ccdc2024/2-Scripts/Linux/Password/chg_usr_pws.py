#! /bin/bash

from os import system
from random import choices
import string

usr_accts, ref, uid_values = [], ["bash", "sh", "zsh"], []

root_pw = '1qazxsW@1' #nothing to see here

with open("disable_mfa.txt", "w") as dLog:
    pass
with open("enable_mfa.txt", "w") as eLog:
    pass


def run():
    #Get user accts
    with open("/etc/passwd") as uLog:
        usrs = uLog.readlines()
        for usr in usrs:
            usr_values = usr.rstrip().split(":")
            if any(r in usr for r in ref):
                usr_accts.append((usr_values[0], usr_values[2]))
                uid_values.append(eval(usr_values[2]))

    max_uid = max(sorted(uid_values, reverse=True))

    #Set new passwords
    with open("/temp_store.txt", "w") as pLog:
        pLog.write("**********User Account Modifications**********\n")
        for usr in usr_accts:
            if usr[0] == 'root':
                pr = (usr[0], root_pw, usr[1])
            else:
                resp = ''
                while (resp != "yes" and resp != "no"):
                   resp = input(f"Would you like to change the password for user {usr[0]}? ('yes'/'no'): ")

                if resp == "yes":
                    pr = (usr[0], ''.join((choices(string.ascii_lowercase, k=16))), usr[1])
                    system(f'echo "{pr[0]}:{pr[1]}" | sudo chpasswd')
                    pLog.write(str(pr) + "\n")
            if usr[1] == '0':
                resp = ''
                while (resp != 'yes' and resp != 'no'):
                    resp = input(f"UID 0 found for user {usr[0]}, would you like to change ('yes'/'no'): ")
                if resp == 'yes':
                   print(f"Setting {usr[0]} UID to {max_uid + 1}")
                   system(f'usermod -u {max_uid + 1} {usr[0]}')
                   max_uid += 1
                   pLog.write(f"{usr[0]} UID changed to {max_uid}\n")
                else:
                    pLog.write(f"***{usr[0]} has UID value 0***\n")
            resp = ''
            while (resp != 'yes' and resp != 'no'):
                resp = input("Disable MFA for user? ('yes'/'no'): ")
            if resp == "yes":
                mfa_log = open("disable_mfa.txt", "a")
                mfa_log.write(usr[0] + "\n")
                mfa_log.close()
            else:
                enable_log = open("enable_mfa.txt", "a")
                enable_log.write(usr[0] + "\n")
                enable_log.close()
        pLog.write("**********************************************\n")

if __name__ == "__main__":
    run()
    #system('sudo python3 disable_mfa.py')
    #system('sudo python3 enable_mfa.py')

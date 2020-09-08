#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PATH_FILE_ACCOUNT="$CURRENT_DIR/list_account.csv"

PATH_FILE_AUTHEN="/etc/squid/passwords"

function delete_line_empty_file_csv(){

                sed -i /^$/d "$PATH_FILE_ACCOUNT"

}

function check_file_and_run_script() {
echo "Username,Password" > "$CURRENT_DIR/export_list_account.csv"
echo "" > "$CURRENT_DIR/log_create_list_account"
        if [ -f "$PATH_FILE_ACCOUNT" ]
                then
                        echo -e "File $PATH_FILE_ACCOUNT found !!!"
                # call function delete_line_empty_file_csv
                delete_line_empty_file_csv
                value_line_csv=0
                while IFS=',' read -r username;
                        do
                                if [ $value_line_csv != 0 ]
                                        then
						export USER_SQUID="$username"
						#export PASSWORD_SQUID=`date +%s | sha256sum | base64 | head -c 32 ;`
						export PASSWORD_SQUID=`openssl rand -hex 16`	
						echo "Username: $USER_SQUID" >> "$CURRENT_DIR/log_create_list_account"
						echo "Password: $PASSWORD_SQUID" >> "$CURRENT_DIR/log_create_list_account"
						echo "$USER_SQUID,$PASSWORD_SQUID" >> "$CURRENT_DIR/export_list_account.csv"
						#echo "$USER_SQUID:$(openssl passwd -crypt $PASSWORD_SQUID)" >> "$PATH_FILE_AUTHEN"
						echo "$PASSWORD_SQUID" | htpasswd -i "$PATH_FILE_AUTHEN" "$USER_SQUID"
                                                echo -e "============================== Create $username done Virtual !!! ======================================================"
						echo -e "============================== Create $username done Virtual !!! ======================================================" >> "$CURRENT_DIR/log_create_list_account"
						
                                fi
                                value_line_csv=$value_line_csv+1

                done < "$PATH_FILE_ACCOUNT"

        else
                echo -e "[Waring] File $PATH_FILE_ACCOUNT not found !!!"

        fi

}
delete_line_empty_file_csv
check_file_and_run_script

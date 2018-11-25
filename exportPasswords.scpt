on run
	delay 2
	set path_to_desktop_folder to ((get path to desktop folder from user domain) as text)
	set name_of_me to "safari_passwords"
	set passwords_file_txt to (path_to_desktop_folder & name_of_me & ".csv")
	set passwords_text to "login_uri,login_username,login_password" & return
	tell application "System Events" to tell application process "Safari"
		if (exists window "Passwords") then
			tell window "Passwords" to tell group 1 to tell group 1 to tell scroll area 1 to tell table 1
				set count_of_rows to (get count of rows)
				repeat with int_row from 2 to count_of_rows
					set (selected of row int_row) to true
					tell application "System Events" to key code 36
					tell application "System Events" to tell application process "Safari" to tell window "Passwords" to tell sheet 1
						set this_user_name to (get value of text field 1)
						if (this_user_name is equal to "") then -- null value
							set this_user_name to ("<user name>")
						end if
						set this_password to (get value of text field 2)
						tell scroll area 1 to tell table 1
							set count_of_websites to (get count of rows)
							repeat with int_website from 1 to count_of_websites
								tell row int_website to tell UI element 1
									set this_address to (get value of static text 1)
									set passwords_text to (passwords_text & this_address & "," & this_user_name & "," & this_password & return)
								end tell
							end repeat
						end tell
						tell application "System Events" to key code 36
					end tell
				end repeat
			end tell
		end if
	end tell
	tell application "Finder"
		if (exists (file passwords_file_txt)) then
			move file passwords_file_txt to trash
		end if
	end tell
	try
		close access (file passwords_file_txt)
	end try
	set file_open to (open for access (file passwords_file_txt) with write permission)
	set eof file_open to 0
	write passwords_text to file_open as text
	close access file_open
	tell application "Finder"
		open (file passwords_file_txt)
	end tell
end run

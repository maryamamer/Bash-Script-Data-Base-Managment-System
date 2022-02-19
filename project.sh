#! /bin/bash
Create_DataBase()
{
	read dir
        mkdir DataBases/$dir
}
Connect_DataBase()
{
read dir
if  [ -d "DataBases/$dir" ]
then
	cd DataBases/$dir
        PS3="($dir) "
	echo -n "Connect To DataBase Successfuly"
	echo -e '\U0001F600'
else
	echo "This DataBase Doesnot Exist"
	break
fi
}
Create_Table()
{
echo "Enter Table Name"
read TableName
touch $TableName
echo "Enter how many columns you want to add"
read colno
for (( i=1;i<=$colno;i++ ))
do
	if [ $i -eq 1 ]
	then
		echo "Enter Column $i name (Primary Key)"
                read a[$i]
                echo "Enter Data Type Of Primary Key"
                select datatype in "int" "text"
		do
			colType=$datatype
                        echo -n ${a[$i]} "("$colType")" "|" >> $TableName
                        break
		done
	else
		echo "Enter Column $i name"
		read a[$i]
		echo "Enter Data Type Of Column $i "
		select datatype in "int" "text"
                do
			colType=$datatype
                        echo -n ${a[$i]} "("$colType")" "|" >> $TableName
			break
		done
	fi
done

}


Insert_IntoTable()
{
read TableName
if  [ -f "$TableName" ]
then
	nocol=` awk -F"|" '{ print NF; exit }' $TableName`
	awk -F"|" 'NR==1{ for (i=1; i<NF; i++) { print $i > "colname" }}' $TableName
        echo "" >> $TableName
        for (( i=1; i<$nocol; i++ ))
        do
		if [ $i -eq 1 ]
		then
			echo "Insert to" `sed -n "$i"p colname`
                        read data
                        grep "$data" $TableName > primarykey
                        if ! [ -s primarykey ]
                        then
				datatype=` awk -F"[()]" 'NR==1{{ print $2 }}' $TableName `
				re='^[0-9]+$'
                                if ! [[ $data =~ $re ]]
                                then
					colType="text"
					if [ $datatype = $colType ]
					then
						echo -n $data "       |" >> $TableName
					else
						echo "Please Enter $datatype value"
						break
					fi
				else
					colType="int"
					if [ $datatype = $colType ]
                                        then
					echo -n $data "       |" >> $TableName
					else
                                                echo "Please Enter $datatype value"
						break
                                        fi
				fi
				for (( i=1; i<$nocol; i++ ))
				do
					if [ $i -eq 1 ]
					then
						continue
					else
						echo "Insert to" `sed -n "$i"p colname`
						read data
						datatype=` awk -F"[()]" '{ print $2 }' colname | sed -n "$i"p `
						re='^[0-9]+$'
						if ! [[ $data =~ $re ]]
						then
							colType="text"
							if [ $datatype = $colType ]
		                                        then
								echo -n $data "       |" >> $TableName
							else
								echo "Please Enter $datatype value"
		                                                break
                		                        fi
						else
							colType="int"
							if [ $datatype = $colType ]
                                                        then
								echo -n $data "       |" >> $TableName
							else
                                                                echo "Please Enter $datatype value"
                                                                break
                                                        fi
						fi
					fi
				done
			else
				echo "This Key exsist"
				rm primarykey
				break
			fi
		fi
	done
else
	echo "This Table Doesnot Exist"
        break
fi
}

DeleteFrom_Table()
{
read tablename
echo "Enter Data You Want To Delete"
read -r data
sed "/$data/d" $tablename > tmpfile && mv tmpfile $tablename
}

Update_Table()
{
read tablename
echo "Enter Old Data "
read -r olddata
echo "Enter New Data "
read -r newdata
sed "s/$olddata/$newdata/g" $tablename > tmpfile && mv tmpfile $tablename
}

echo -n "Welcome In DataBase Project"
echo -e '\U0001F60A'
echo "---Main Menu---"
select item in "- Create DataBase" "- List DataBases" "- Connect To DataBases" "- Drop DataBase" "- Exit"
do
	case $REPLY in 
		1) echo "Enter Data Base Name you want to create"
			Create_DataBase
			;;
		2) ls DataBases
			;;
		3) echo "Enter Data Base Name You want To connect to"
			Connect_DataBase

			select item2 in "- Create Table" "- List Tables" "- Drop Table" "- Insert Into Table" "- Select From Table" "- Delete From Table" "- Update Table" "- Return To List"
			do
				case $REPLY in
					1) Create_Table
							;;
					2) ls
						;;
					3) echo "Enter Table Name You Want To Drop It"
                                                read TableName
						if  [ -f "$TableName" ]
						then
							rm $TableName
							echo "Table Deleted"
						else
							echo"This Table Doesnot Exist"
						fi
						;;
					4) echo "Enter Table Name You Want To Insert In"
						Insert_IntoTable	
						;;
					5) echo "Enter Table name you want to display"
						read tablename
						cat $tablename
						;;
					6) echo "Enter Table Name You Want To Delete From "
						DeleteFrom_Table
						;;
					7) echo "Enter Table Name You Want To Update "
						Update_Table
						;;
					8) PS3="#"
					   cd ..
					   cd ..
					   . ./project.sh
						;;
				esac	
			done
			;;
		4) echo "Enter Data Base Name you want to drop "
                        read dir
                        rm -r DataBases/$dir
		        cd DataBases
			echo -n "DataBase Deleted Successfully"
			echo -e '\U0001F600'
			PS3="#"	
			;;
		5) 	echo -n "Good Bye"
			echo -e '\U0001F60A'	
			exit
			;;
		*) echo "Enter Valid Option"
			;;	
	esac
done

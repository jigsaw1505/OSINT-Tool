function display(){
echo "Choose your option"
echo"1. Username search"
echo"2. Domain search"
echo"3. Mail search"
echo"4. Exit"
}
while true do
display
read -r choice
case $choise in
1)
    bash src/uname.sh
    ;;
2)
    bash src/domain.sh
    ;;
3) 
    bash src/email.sh
    ;;
4)
    exit
    ;;
*)
    echo"enter valid option"
    esac
    done
    
    

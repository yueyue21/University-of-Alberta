import cx_Oracle
import datetime
import random  

def update_patient():
    try:
        login='xiaocong/samisda38@gwynne.cs.ualberta.ca:1521/CRS'
        connection = cx_Oracle.connect(login)
        curs = connection.cursor()
        cursUpdate = connection.cursor()
        cursInsert = connection.cursor()
        
        list_patient_no=[]
        curs.execute("SELECT Health_care_no FROM patient")
        row2 = curs.fetchone()
        while row2:
            list_patient_no.append(row2[0])
            row2 = curs.fetchone() 
        answer=input("Have you registed?(y/n):")

        if answer == 'y':#update
            stop =1
            health_no=int(input("enter your health care number:"))
            while(health_no=="" or health_no not in list_patient_no):
                health_no=int(input("number not exist.\nenter your health care number:"))
            print("Patient Information Update")
            while (stop==1):
                print("1.name")
                print("2.address")
                print("3.birthday")
                print("4.phone number")
                print("5.exit")
    
                choice1=int(input("Please choose the information you want to update(1,2,3,4,5):"))
                if choice1==1:
                    name=input("Please enter your new name(100 cahracters):")
                    update1="update patient set name='"+name+"'"+" where health_care_no='"+str(health_no)+"'"
                    cursUpdate.execute(update1)
                    print("Data updated!")
                elif choice1 ==2:
                    address=input("Please enter you new address(200 characters):")
                    update2="update patient set address='"+address+"'"+" where health_care_no='"+str(health_no)+"'"
                    cursUpdate.execute(update2)
                    print("Data updated!")
                elif choice1 ==3:
                    birth_day=input("Please enter your new birthday(eg:19-July-1988):")
                    update3="update patient set birth_day='"+birth_day+"'"+" where health_care_no='"+str(health_no)+"'"
                    cursUpdate.execute(update3)
                    print("Data updated!")
                elif choice1 ==4:
                    phone=input("Please enter your new phone number(10 characters):")
                    update4="update patient set phone='"+phone+"'"+" where health_care_no='"+str(health_no)+"'"
                    cursUpdate.execute(update4)
                    print("Data updated!")
                elif choice1 ==5:
                    stop=0  #----------------------recall the main
                connection.commit()
        elif answer == 'n':#insert
            health_no=int(input("enter your health care number:"))
            while(health_no=="" or health_no in list_patient_no):
                health_no=int(input("enter your health care number:"))
            print("you are going to enter 4 personal infomation")
            name=input("Please enter your new name(100 cahracters):")
            address=input("Please enter you new address(200 characters):")
            birth_day=input("Please enter your new birthday(eg:01-October-1985:")
            phone=input("Please enter your new phone number(10 characters):")
            new_patient=(int(health_no),name,address,birth_day,phone)
            cursInsert.setinputsizes(int, 100, 200, datetime.date, 10)
            cursInsert.execute("insert into patient (health_care_no, name, address, birth_day, phone)"
                                  "VALUES (:1, :2, :3, :4, :5)", new_patient)
            connection.commit()
    except:
        print("Invalid input try again")
        update_patient()
        
    curs.close()
    cursInsert.close()
    cursUpdate.close()
    connection.close()      
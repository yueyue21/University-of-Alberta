from circular_queue import CircularQueue
q=CircularQueue(3)
vip=CircularQueue(3)
def main():
    input1= input('Add, Serve, or Exit:')
    input2 = input('Enter the customer name:')
    input3 = input('Is the customer VIP?')
    if input1 == 'Serve' :
        if q.is_empty() and vip.is_empty():
            print('Error:Both queues are empty')
            main()
        else:
            if vip.is_empty():
                print(q.peek(),'has been served.')
                q.dequeue()
                rpp()
            else:
                print(vip.peek(),'has been served.')
                vip.dequeue()
                rpp()
            main()
    elif input1 =='Add':
        if q.size()==3 and input3=='false':
            print('Error: Normalcustomers queue is full')
            rpp()
            main()
        elif input3 == 'true' and vip.size()==3:
            print('Error: VIP customers queueis full')
            rpp()
            main()
        elif input3 == 'false' and q.size()<3:
            q.enqueue(input2)
            rpp()
            main()
        elif input3 == 'true' and vip.size()<3:
            vip.enqueue(input2)
            rpp()
            main()
    elif input1 == 'Exit':
        return
    

main()
def rpp():
    print('Current lineup:')
    print('Normal customers queue:',q.__str__())
    print('VIP customers queue:',vip.__str__())

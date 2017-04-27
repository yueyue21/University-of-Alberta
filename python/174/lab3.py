a = eval(input("Enter the branches you want:"))
import turtle
t = turtle.Turtle()
def star(t,n,length):
    t.lt(90)
    for i in range(n):
        t.fd(length)
        t.bk(length)
        t.rt(360/n)
             
star(t,a,100)
turtle.exitonclick()



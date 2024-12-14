using HorizonSideRobots
HorizonSideRobots.move!(robot,side,num_steps)=for _ in 1:num_steps move!(robot,side) end
inverse(side::HorizonSide)=HorizonSide((Int(side)+2)%4)
mutable struct ChessRobot
    robot::Robot
    flag::Bool
end
function HorizonSideRobots.move!(robot::ChessRobot,side)
    (robot.flag) && (putmarker!(robot.robot))
    move!(robot.robot,side)
    robot.flag=(!robot.flag)
end

HorizonSideRobots.isborder(robot::ChessRobot,side)=isborder(robot.robot,side)
function do_upora!(robot,side)
    counter=0
    while (!isborder(robot,side))
        move!(robot,side)
        counter+=1
    end
    return counter
end
function to_start!(robot)
    path=[]
    while (!isborder(robot,West) || !isborder(robot,Sud))
        x=do_upora!(robot,West)
        y=do_upora!(robot,Sud)
        push!(path,[Ost,x])
        push!(path,[Nord,y])
    end
    return path
end
function to_dot!(robot,path)
    for i in length(path):-1:1
        move!(robot,path[i][1],path[i][2])
    end
end
function movetoend!(stop_condition::Function,robot,side)
    counter=0
    while (!stop_condition())
        move!(robot,side)
        counter+=1
    end
    return counter
end
function snake!(stop_condition::Function,robot,sides::NTuple{2,HorizonSide},x)
    s=sides[1]
    
    while ((!(stop_condition())) && (!isborder(robot,sides[2])))
        c=0
        while (!isborder(robot,s) && c<x)
            c+=movetoend!(()->stop_condition() || isborder(robot,s),robot,s)
            if c<x
                c+=throughborder!(robot,s)
            end
        end
        movetoend!(()->stop_condition() || isborder(robot,s),robot,s)
        s=inverse(s)
        move!(robot,sides[2])
    end
    movetoend!(()->stop_condition() || isborder(robot,s),robot,s)
end

function borderside(robot,side1,side2,side3)
    return (isborder(robot,side3) && (isborder(robot,side1) || isborder(robot,side2)))
end

function f(x::Int)
    return (x^2)<-1
end

function throughborder!(robot,side)
    c=0
    c1=0
    while (isborder(robot,side))
        move!(robot,Nord)
        c+=1
    end
    move!(robot,side)
    c1+=1
    while (isborder(robot,Sud))
        move!(robot,side)
        c1+=1
    end
    move!(robot,Sud,c)
    return c1
end

function main(robot)
    r=ChessRobot(robot,true)
    path=to_start!(r)
    x=do_upora!(r,Ost)
    move!(r,West,x)
    snake!(()->f(2),r,(Ost,Nord),x)
    to_start!(r)
    to_dot!(r,path)
end

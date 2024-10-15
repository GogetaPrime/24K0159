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
    x=do_upora!(robot,West)
    y=do_upora!(robot,Sud)
    return (x,y)
end
function to_dot!(robot,coord::NTuple{2,Int})
    move!(robot,Nord,coord[2])
    move!(robot,Ost,coord[1])
end
function movetoend!(stop_condition::Function,robot,side)
    counter=0
    while (!stop_condition() && !isborder(robot,side))
        move!(robot,side)
        counter+=1
    end
    return counter
end
function snake!(stop_condition::Function,robot,sides::NTuple{2,HorizonSide})
    s=sides[1]
    while (!(stop_condition()) && !isborder(robot,sides[2]))
        movetoend!(()->stop_condition(),robot,s)
        if stop_condition()
            break
        end
        s=inverse(s)
        move!(robot,sides[2])
    end
    movetoend!(()->stop_condition(),robot,s)
end
function main(robot)
    r=ChessRobot(robot,true)
    path=to_start!(r)
    snake!(()->isborder(robot,Nord)&&(isborder(robot,Ost)),r,(Ost,Nord))
    to_start!(r)
    to_dot!(r,path)
end
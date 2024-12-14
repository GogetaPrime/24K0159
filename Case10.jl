using HorizonSideRobots

inverse(side::HorizonSide)=HorizonSide(mod((Int(side)+2),4))

HorizonSideRobots.move!(robot,side,num_steps)=for _ in 1:num_steps move!(robot,side) end


function do_upora!(robot,side)
    counter=0
    while (!isborder(robot,side))
        move!(robot,side)
        counter+=1
    end
    return counter
end
mutable struct CoordRobot
    robot::Robot
    x::Int
    y::Int
end
HorizonSideRobots.isborder(robot::CoordRobot,side)=isborder(robot.robot,side)

HorizonSideRobots.putmarker!(robot::CoordRobot)=putmarker!(robot.robot)

function HorizonSideRobots.move!(robot::CoordRobot,side::HorizonSide)
    
    if (side==Nord)
        robot.y+=1
    elseif (side==Sud)
        robot.y-=1
    elseif (side==Ost)
        robot.x+=1
    else
        robot.x-=1
    end
    move!(robot.robot,side)
end
function passline!(robot::CoordRobot,side,N)
    while (!isborder(robot,side))
        (((robot.x%(2*N))<N) == ((robot.y%(2*N))<N)) && (putmarker!(robot))
        move!(robot,side)
    end
end
function border!(robot,N)
    side=Ost
    while (!isborder(robot,Nord))
        passline!(robot,side,N)
        (((robot.x%(2*N))<N) == ((robot.y%(2*N))<N)) && (putmarker!(robot))
        move!(robot,Nord)
        side=inverse(side)
    end
    passline!(robot,side,N)
    (((robot.x%(2*N))<N) == ((robot.y%(2*N))<N)) && (putmarker!(robot))
end
function main(robot,N)
    robot=CoordRobot(robot,0,0)
    y=do_upora!(robot,Sud)
    x=do_upora!(robot,West)
    robot.x=0
    robot.y=0
    border!(robot,N)
    do_upora!(robot,Sud)
    do_upora!(robot,West)
    move!(robot,Nord,y)
    move!(robot,Ost,x)
end
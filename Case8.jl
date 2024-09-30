using HorizonSideRobots
rotate(side::HorizonSide)=HorizonSide((Int(side)+1)%4)
function HorizonSideRobots.move!(robot,side,num_steps)
    for _ in 1:num_steps
        if (!ismarker(robot))
        move!(robot,side)
        else
            break
        end
    end
end

function to_marker!(robot)
step=1
side=Ost
flag=true
while (true)
    move!(robot,side,step)
    side=rotate(side)
    flag=!flag
    flag && (step+=1)
    if (ismarker(robot))
        break
    end
end
end
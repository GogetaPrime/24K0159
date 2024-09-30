using HorizonSideRobots
inverse(side::HorizonSide)=HorizonSide((Int(side)+2)%4)
function HorizonSideRobots.move!(robot,side,num_steps)
    for _ in 1:num_steps
        move!(robot,side)
    end
end

function to_exit!(robot)
step=1
side=Ost
while (isborder(robot,Nord))
    move!(robot,side,step)
    side=inverse(side)
    step+=1
end
end
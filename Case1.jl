using HorizonSideRobots
inverse(side::HorizonSide)=HorizonSide((Int(side)+2)%4)
function HorizonSideRobots.move!(robot,side,num_steps::Integer)
    for _ in 1:num_steps
        move!(robot,side)
    end
end
function markline!(robot,side)
    counter=0
    while !isborder(robot,side)
        move!(robot,side)
        putmarker!(robot)
        counter+=1
    end
    return counter
end
function cross!(robot)
    for side ∈ (Nord,Ost,Sud,West)
        y=markline!(robot,side)
        move!(robot,inverse(side),y)
    end
end
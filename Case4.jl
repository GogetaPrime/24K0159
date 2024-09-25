using HorizonSideRobots
rotate(side::HorizonSide)=HorizonSide((Int(side)+3)%4)
inverse(side::HorizonSide)=HorizonSide((Int(side)+2)%4)
function HorizonSideRobots.move!(robot,side,num_steps)
    for _ in 1:num_steps
        move!(robot,side)
    end
end
function diagmove!(robot,side1,side2)
    move!(robot,side1)
    move!(robot,side2)
end
function diagline!(robot,side1,side2)
    counter=0
    while (!isborder(robot,side1) && !isborder(robot,side2))
        diagmove!(robot,side1,side2)
        putmarker!(robot)
        counter+=1
    end
    move!(robot,inverse(side1),counter)
    move!(robot,inverse(side2),counter)
end
function diagcross!(robot)
    for side ∈ (Nord,Ost,Sud,West)
        diagline!(robot,side,rotate(side))
    end
end

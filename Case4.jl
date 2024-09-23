using HorizonSideRobots
function HorizonSideRobots.move!(robot,side,num_steps)
    for _ in 1:num_steps
        move!(robot,side)
    end
end
function do_upora!(robot,side)
    counter=0
    while !isborder(robot,side)
        move!(robot,side)
        counter+=1
    end
    counter+=1
end
inverse(side::HorizonSide)=HorizonSide((Int(side)+2)%4)
rotate(side::HorizonSide)=HorizonSide((Int(side)+1)%4)
function diagmark!(robot,side1,side2)
    if (!isborder(robot,side1) && !isborder(robot,side2))
    move!(robot,side1)
    move!(robot,side2)
    end
end
function diagline!(robot,side1,side2,num_marks)
    for _ in 1:num_marks
        if (!isborder(robot,side1) && !isborder(robot,side2))
        diagmark!(robot,side1,side2)
        putmarker!(robot)
        end
    end
    for _ in 1:num_marks
        if (!isborder(robot,inverse(side1)) && !isborder(robot,inverse(side2)))
        diagmark!(robot,inverse(side1),inverse(side2))
        end
    end
end
function cross!(robot)
    x1=do_upora!(robot,West)
    move!(robot,Ost,x1)
    x2=do_upora!(robot,Ost)
    move!(robot,West,x2)
    y1=do_upora!(robot,Sud)
    move!(robot,Nord,y1)
    y2=do_upora!(robot,Nord)
    move!(robot,Sud,y2)
    diagline!(robot,Nord,Ost,min(x2,y2))
    diagline!(robot,Sud,Ost,min(x2-1,y1-1))
    diagline!(robot,Sud,West,min(x1-1,y1-1))
    diagline!(robot,Nord,West,min(x1-1,y2-1))

end
function chess!(robot)
    numtosud=do_upora!(robot,Sud)
    numtowest=do_upora!(robot,West)
    move!(robot,Ost,((numtosud+numtowest)%2))
    crossboard!(robot,numtowest%2,numtosud%2)
    do_upora!(robot,Sud)
    do_upora!(robot,West)
    move!(robot,Nord,numtosud)
    move!(robot,Ost,numtowest)
end
using HorizonSideRobots
rotate(side::HorizonSide)=HorizonSide((Int(side)+3)%4)
inverse(side::HorizonSide)=HorizonSide((Int(side)+2)%4)
function HorizonSideRobots.move!(robot,side,num_steps)
    for _ in 1:num_steps
        move!(robot,side)
    end
end
function markline!(robot,side)
    while (isborder(robot,side))
        putmarker!(robot)
        move!(robot,rotate(side))
    end
end
function markrec!(robot)
    for side ∈ (Nord,West,Sud,Ost)
        markline!(robot,side)
        putmarker!(robot)
        move!(robot,side)
    end
    
end
function do_upora!(robot,side)
    counter=0
    while (!isborder(robot,side))
        move!(robot,side)
        counter+=1
    end
    return counter
end
function markend!(robot,side,n)
    n1=do_upora!(robot,side)
    if (n1<n)
        putmarker!(robot)
    end
    move!(robot,inverse(side),n1)
end
function findborder!(robot,y)
    tempvert=do_upora!(robot,Nord)
    temphor=0
    move!(robot,Sud,tempvert)
    while (tempvert==y)
        move!(robot,Ost)
        temphor+=1
        tempvert=do_upora!(robot,Nord)
        move!(robot,Sud,tempvert)
    end
    move!(robot,Nord,tempvert)
    return [temphor,tempvert]
end
function to_start!(robot,horpos,vertpos)
    move!(robot,Nord,vertpos)
    counter_to_ost=0
    while ((!isborder(robot,Ost)) && (counter_to_ost<horpos))
        move!(robot,Ost)
        counter_to_ost+=1
    end
    if (counter_to_ost<horpos)
        counter_to_nord=0
        while(isborder(robot,Ost))
            move!(robot,Nord)
            counter_to_nord+=1
        end
        move!(robot,Ost,horpos-counter_to_ost)
        move!(robot,Sud,counter_to_nord)
    end
end
function mark!(robot)
    x=do_upora!(robot,West)
    y=do_upora!(robot,Sud)
    x+=do_upora!(robot,West)
    y+=do_upora!(robot,Sud)
    vertical_size=do_upora!(robot,Nord)
    do_upora!(robot,Sud)
    coordarr=findborder!(r,vertical_size)
    markrec!(r)
    move!(robot,Sud,coordarr[2])
    move!(robot,West,coordarr[1])
    to_start!(robot,x,y)
end

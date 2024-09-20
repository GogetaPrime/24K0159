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
function markline!(robot,side,step=0)
    count=0
    move!(robot,side,step)
    while !isborder(robot,side)
        if (count%2==0)
            putmarker!(robot)
        end
        count+=1
        move!(robot,side)
    end
    if (count%2==0)
        putmarker!(robot)
    end
end
function crossboard!(robot,x::Int,y::Int)
    side=Ost
    markline!(robot,side)
    side=inverse(side)
    while !isborder(robot,Nord)
        move!(robot,Nord)
        move!(robot,side,((x+y)%2))
        markline!(robot,side)
        side=inverse(side)
    end
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
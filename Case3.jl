using HorizonSideRobots
inverse(side::HorizonSide)=HorizonSide((Int(side)+2)%4)
function HorizonSideRobots.move!(robot,side,num_steps::Integer)
    for _ in 1:num_steps
        move!(robot,side)
    end
end
function do_upora(robot,side)
    counter=0
    while !isborder(robot,side)
        move!(robot,side)
        counter+=1
    end
    return counter
end
function markline2!(robot,side)
    if !ismarker(robot)
        putmarker!(robot)
    end
    while !isborder(robot,side)
        move!(robot,side)
        putmarker!(robot)
    end
end
function markboard!(robot)
    side=Ost
    markline2!(robot,side)
    side=inverse(side)
    while !isborder(robot,Nord)
        move!(robot,Nord)
        markline2!(robot,side)
        side=inverse(side)
    end
end
function board!(robot)
    num_to_sud=do_upora(robot,Sud)
    num_to_west=do_upora(robot,West)
    markboard!(robot)
    do_upora(robot,Sud)
    do_upora(robot,West)
    move!(robot,Nord,num_to_sud)
    move!(robot,Ost,num_to_west)
end
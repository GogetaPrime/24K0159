using HorizonSideRobots
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
    while !isborder(robot,side)
        move!(robot,side)
        putmarker!(robot)
    end
end
function perimeter!(robot)
    num_to_sud=do_upora(robot,Sud)
    num_to_west=do_upora(robot,West)
    for side ∈ (Nord,Ost,Sud,West)
        markline2!(robot,side)
    end
    move!(robot,Nord,num_to_sud)
    move!(robot,Ost,num_to_west)
end
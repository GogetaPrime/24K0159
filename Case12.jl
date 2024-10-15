using HorizonSideRobots
inverse(side::HorizonSide)=HorizonSide((Int(side)+2)%4)
function HorizonSideRobots.move!(robot,side,num_steps)
    for _ in 1:num_steps
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
function borderlineup!(robot,side)
    borders=0
    prev=0
    current=0
    while (!isborder(robot,side))
        move!(robot,side)
        (isborder(robot,Nord)) && (current=2)
        ((!isborder(robot,Nord)) && (prev>0)) && (current-=1)
        ((current==0) && (prev>0)) && (borders+=1)
        prev=current
    end
    (!isborder(robot,Nord)) && (prev>0) && (borders+=1)
    return borders
end
function bordersall!(robot)
    side=Ost
    borders=0
    while (!isborder(robot,Nord))
        borders+=borderlineup!(robot,side)
        side=inverse(side)
        move!(robot,Nord)
    end
    return borders
end
function to_start!(robot)
    x=do_upora!(robot,West)
    y=do_upora!(robot,Sud)
    return (x,y)
end
function to_dot!(robot,coord::NTuple{2, Int})
    move!(robot,Nord,coord[2])
    move!(robot,Ost,coord[1])
end
function main(robot)
    coordinates=to_start!(robot)
    bord=bordersall!(robot)
    do_upora!(robot,Sud)
    (!isborder(robot,West)) && (do_upora!(robot,West))
    to_dot!(robot,coordinates)
    return bord
end
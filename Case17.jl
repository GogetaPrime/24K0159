using HorizonSideRobots
left(side::HorizonSide)=HorizonSide((Int(side)+1)%4)
function movetoend!(stop_condition::Function,robot,side)
    n=0
    while (!stop_condition())
    move!(robot,side)
    n+=1
    end
    return n
end
function find_direct!(stop_condition,robot,side,nmax_steps)
    n=0
    while (!stop_condition() && n<nmax_steps)
        move!(robot,side)
        n+=1
    end
    return stop_condition()
end
function spiral!(stop_condition::Function,robot)
    nmax_steps=1
    s=Nord
    while !find_direct!(stop_condition,robot,s,nmax_steps)
        (s in (Nord,Sud)) && (nmax_steps+=1)
        s=left(s)
    end
end
function main(robot)
        spiral!(()->ismarker(robot),robot)
end
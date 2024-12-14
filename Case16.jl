using HorizonSideRobots
inverse(side::HorizonSide)=HorizonSide((Int(side)+2)%4)
HorizonSideRobots.move!(robot,side,num_steps) = for _ in 1:num_steps move!(robot,side) end
function movetoend!(stop_condition::Function,robot,side)
    counter=0
    while (!stop_condition())
        move!(robot,side)
        counter+=1
    end
    return counter
end
function shuttle!(stop_condition::Function,robot,start_side)
    s=start_side
    counter=0
    while (!stop_condition(s))
        move!(robot,s,counter)
        s=inverse(s)
        counter+=1
    end
end

    
function main(robot)
    shuttle!((Sud)->(!isborder(robot,Nord)),robot,Ost)
end
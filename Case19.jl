using HorizonSideRobots
function toborder!(robot,side)
    if (!isborder(robot,side))
        move!(robot,side)
        toborder!(robot,side)
    end
end
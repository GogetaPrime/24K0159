using HorizonSideRobots
function do_upora!(robot,side)
    counter=0
    while (!isborder(robot,side))
        counter+=1
        move!(robot,side)
    end
    return counter
end
function HorizonSideRobots.move!(robot,side,num_steps)
    for _ in 1:num_steps
        move!(robot,side)
    end
end
function markline!(robot,side)
    while (!isborder(robot,side))
        putmarker!(robot)
        move!(robot,side)
    end
end
function perimeter!(robot)
    for side ∈ (Nord,Ost,Sud,West)
        markline!(robot,side)
    end
end
function markdots!(robot,hor_pos,vert_pos)
    positionarr=[hor_pos,vert_pos]
    hor_size=do_upora!(robot,Ost)
    do_upora!(robot,West)
    vert_size=do_upora!(robot,Nord)
    do_upora!(robot,Sud)
    move!(robot,Nord,vert_pos)
    putmarker!(robot)
    do_upora!(robot,Nord)
    move!(robot,Ost,hor_pos)
    putmarker!(robot)
    do_upora!(robot,Ost)
    move!(robot,Sud,vert_size-vert_pos)
    putmarker!(robot)
    do_upora!(robot,Sud)
    move!(robot,West,hor_size-hor_pos)
    putmarker!(robot)
    do_upora!(robot,West)
end
function to_angle!(robot)
    path=[]
    x=0
    y=0
    xtemp=do_upora!(robot,West)
    ytemp=do_upora!(robot,Sud)
    while (xtemp!=0 || ytemp!=0)
        push!(path,[Ost,xtemp])
        push!(path,[Nord,ytemp])
        x+=xtemp
        y+=ytemp
        xtemp=do_upora!(robot,West)
        ytemp=do_upora!(robot,Sud)
    end
    push!(path,[Ost,xtemp])
    push!(path,[Nord,ytemp])
    return [[x,y],path]
end
function to_dot!(robot,path)
    for i in 0:(length(path)-1)
        move!(robot,path[length(path)-i][1],path[length(path)-i][2])
    end
end
function markperim!(robot)
        arrdata=to_angle!(robot)
        perimeter!(robot)
        to_dot!(robot,arrdata[2])
end
function marksomedots!(robot)
        arrdata=to_angle!(robot)
        x,y=arrdata[1]
        markdots!(robot,x,y)
        to_dot!(robot,arrdata[2])
end

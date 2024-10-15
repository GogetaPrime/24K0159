using HorizonSideRobots
rotate(side::HorizonSide)=HorizonSide((Int(side)+1)%4)
inverse(side::HorizonSide)=HorizonSide((Int(side)+2)%4)
function HorizonSideRobots.move!(robot,side,num_steps)
    for _ in 1:num_steps
        move!(robot,side)
    end
end
function distance!(robot,side)
    counter=0
    while (!isborder(robot,side))
        move!(robot,side)
        counter+=1
    end
    move!(robot,inverse(side),counter)
    return counter
end
function do_upora!(robot,side)
    counter=0
    while (!isborder(robot,side))
        move!(robot,side)
        counter+=1
    end
    return counter
end
function drawline!(robot,side,size)
    for _ in 1:size
        putmarker!(robot)
        if (!isborder(robot,side)) #Граничный случай для правых квадартов
            move!(robot,side)
        else
            size-=1
        end
    end
    move!(robot,inverse(side),size)
end
function drawsquare!(robot,size)
    for _ in 1:size
        drawline!(robot,Ost,size) 
        if  (!isborder(robot,Nord)) #Граничный случай для верхних квадратов
            move!(robot,Nord)
        else
            size-=1
        end
    end
    move!(robot,Sud,size)
end
function drawsquaredline!(robot,side,n)
    
    while (distance!(robot,side)>=(n-1))
        drawsquare!(robot,n)
        moveneed!(robot,side,2*n)
    end
end
function moveneed!(robot,side,n)
    for _ in 1:(n)
        (!isborder(robot,side))&&(move!(robot,side))
    end
end
function markboard!(robot,n)
    side=Ost
    x=distance!(robot,Ost)
    flag=false
    while (distance!(robot,Nord)>=(n-1))
        do_upora!(robot,inverse(side))
        (flag && (((x+1)%(2*n))>0)) && move!(robot,side,((x+1)%(2*n)))
        flag && move!(robot,side,n-1)
        #flag && moveneed!(robot,side,n-1)
        drawsquaredline!(robot,side,n)
        side=inverse(side)
        flag=!flag
        moveneed!(robot,Nord,n)
    end
end
function chessquare!(robot,n)
    y=do_upora!(robot,Sud)
    x=do_upora!(robot,West)
    markboard!(robot,n)
    do_upora!(robot,Sud)
    do_upora!(robot,West)
    move!(robot,Nord,y)
    move!(robot,Ost,x)
end
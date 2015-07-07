function mask=horizontal_line_detector(im,alfa,thr)

    step=im';
    t=max(dodown(step,alfa),doup(step,alfa));
    b=max(dodown(-step,alfa),doup(-step,alfa));
    maskt=t>max(max(t)).*thr;
    maskb=b>max(max(b)).*thr;
   
    mask=maskt'|maskb';
    
end

function [s1]=dodown(step,alfa)
    [strength edir]=vtrace_down(step,alfa);    
    s1=contour_up(strength,edir,alfa);
end

function [s1]=doup(step,alfa)
    [strength edir]=vtrace_up(step,alfa);
    s1=contour_down(strength,edir,alfa);
end

% This function search for pixel the best neighbour in the top row 
% and accumulate their values as a function of the intensity differences
% and alfa. Is also store the direction of the best neighbour.top=0,top_left=-1,top_right=1;
function [strength edir]=vtrace_down(im,alfa)
[m n]=size(im);
edir=zeros(m,n);
strength=zeros(m,n);
beta=1-alfa;

temp=im;
 for i=2:m 
     j=1;     
     last=temp(i-1,j);
     lastr=temp(i-1,j+1);         
     if (lastr>last)
         last=lastr;
         edir(i,j)=1;
     end
     temp(i,j)=alfa.*(last-temp(i,j))+temp(i,j);         
         
     for  j=2:n-1
         last=temp(i-1,j);
         lastr=temp(i-1,j+1);
         lastl=temp(i-1,j-1);
         
         if (lastl>last)
             last=lastl;
             edir(i,j)=-1;
         end        
         
         if (lastr>last)
             last=lastr;
             edir(i,j)=1;
         end
         temp(i,j)=alfa.*(last-temp(i,j))+temp(i,j);
     end     
     j=n;     
     last=temp(i-1,j);
     lastl=temp(i-1,j-1);
         
     if (lastl>last)
         last=lastl;
         edir(i,j)=-1;
     end        
     temp(i,j)=alfa.*(last-temp(i,j))+temp(i,j);
     
 end
strength=temp;
end

% This function is similar to vtrace_down but the values are computed from
% bottom to top, indeed vtrace_up=vtrace_down(flipud(step),alfa);
function [strength edir]=vtrace_up(im,alfa)
[m n]=size(im);
edir=zeros(m,n);
strength=zeros(m,n);
beta=1-alfa;
temp=im;

 for i=m:-1:2 
     j=1;
     last=temp(i,j);
     lastr=temp(i,j+1);         
     if (lastr>last)
        last=lastr;
        edir(i-1,j)=1;
     end   
     temp(i-1,j)=alfa.*(last-temp(i-1,j))+temp(i-1,j);
         
     for  j=2:n-1
         last=temp(i,j);
         lastr=temp(i,j+1);
         lastl=temp(i,j-1);
         if (lastl>last)
             last=lastl;
             edir(i-1,j)=-1;
         end        
         
         if (lastr>last)
             last=lastr;
             edir(i-1,j)=1;
         end   
         temp(i-1,j)=alfa.*(last-temp(i-1,j))+temp(i-1,j);
     end
     j=n;
     last=temp(i,j);         
     lastl=temp(i,j-1);
     if (lastl>last)
         last=lastl;
         edir(i-1,j)=-1;
     end        
     temp(i-1,j)=alfa.*(last-temp(i-1,j))+temp(i-1,j);
     
     
 end
strength=temp;
end


%In this function the pixels are weakened by beta. Then the image strength
%from the last processed row will be weakened by alfa and added to the
%pixel
function [s1]=contour_down(im,edir,alfa)
[m n]=size(im);
beta=1-alfa;
temp=im;

 for i=2:m 
     temp(i,:)=beta.*temp(i,:);
     for  j=1:n  
         temp(i,j+edir(i-1,j))=temp(i,j+edir(i-1,j))+ alfa.*temp(i-1,j);
     end
 end
  s1=temp;
end



% This function is similar to contour_down but the values are computed from
% bottom to top, indeed contour_up=contour_down(flipud(step),alfa);
function [s1]=contour_up(im,edir,alfa)
[m n]=size(im);
beta=1-alfa;
temp=im;


for i=m-1:-1:1 
    temp(i,:)=beta.*temp(i,:);
    for  j=1:n
        temp(i,j+edir(i+1,j))=temp(i,j+edir(i+1,j))+ alfa.*temp(i+1,j);
    end
end
s1=temp;
end

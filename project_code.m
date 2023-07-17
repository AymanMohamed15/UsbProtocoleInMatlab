clc
clear
id=fopen('input.txt');
bit_stream=fscanf(id,'%f',[1 2000]);
fclose(id);

%the number of bits 
the_end_of_bitStream = 2000;

%to calculate the number of ones 
ones_counter=0;
%for while loop for stuffing bit
j_whileCounter=1;

%number of adding 0 after 5 ones
number_of_adding_stuffing=0;
%counter for while loop for adding three bits 000 after 32 bit
k=1;
%counter for multiple of 32
number_reptition_32=1;
%counter for mutiple of adding three bits
number_of_adding_threebits=0;

bit_stream(1:8)=[0 0 0 0 0 0 0 1];
%TO STORE THE MAIN BIT_STREAM TO CHECK THE VALUE AFTER THE OPERATION
store_bit_stream=bit_stream;
%for loop to NRZI
for i=2:1:the_end_of_bitStream
    if i==2
   if bit_stream(i)==0
       z=i-1;
       if bit_stream(z)== 1
            bit_stream(z)= 0;
       else
            bit_stream(z)= 1;
       end       
   end
    else
       z=i-1;
         if bit_stream(i)==0
            if bit_stream(z)== 1
            bit_stream(i)= 0;
            else
            bit_stream(i)= 1;
            end 
         else
             bit_stream(i)=bit_stream(z);
         end
end
end
%while loop to find five ones simultaneously

while (j_whileCounter<the_end_of_bitStream)
    if (bit_stream(j_whileCounter)==1)
        if (j_whileCounter==the_end_of_bitStream)
            break;
        end
        if(bit_stream(j_whileCounter+1)==bit_stream(j_whileCounter))
        ones_counter = ones_counter+1;
        else
        ones_counter=0;
        end
    end
    if ones_counter==4
        bit_stream=[bit_stream(1:j_whileCounter+1) 0 bit_stream(j_whileCounter+2:the_end_of_bitStream)];
        the_end_of_bitStream=the_end_of_bitStream+1;
        ones_counter=0;
        number_of_adding_stuffing= number_of_adding_stuffing+1;
    end
    j_whileCounter=j_whileCounter+1;
end

%adding 000 after 32 bit

while (k<=the_end_of_bitStream)
    if(k==(32*number_reptition_32+3*number_of_adding_threebits))
        bit_stream =[bit_stream(1:k) 0 0 0 bit_stream(k+1:the_end_of_bitStream)];
        the_end_of_bitStream=the_end_of_bitStream+3;
        k=k+3;
        number_reptition_32=number_reptition_32+1;
        number_of_adding_threebits=number_of_adding_threebits+1;
    end
    k=k+1;
end

%to make the total bits number is divisible by 32

if (mod(the_end_of_bitStream,32)~=0)
    number_for_last_packet=32-mod(the_end_of_bitStream,32);
%     the_end_of_bitStream=the_end_of_bitStream+y;
    new_bit=zeros(1,number_for_last_packet);
    bit_stream=[bit_stream new_bit] ;
end



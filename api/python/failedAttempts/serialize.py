def serialize(data_type,data_count,data,msg_type):
    #variables to be used later
    one='\x01'
    zero='\x00'

    #define data
    d=data
    d_count=data_count

    #message type (async,sync,response)
    m_type=chr(msg_type)

    if ( data_type < 0 ):
        d_type=chr(256+data_type)
        m_length=chr(data_count+9)+3*zero
        msg = one+m_type+2*zero+m_length+d_type+bytes(data,"utf-8")
        print(msg)


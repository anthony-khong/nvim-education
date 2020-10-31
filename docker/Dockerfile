FROM nickblah/luajit:lua52compat-luarocks-ubuntu

RUN apt-get update && apt-get install -y build-essential

RUN apt-get install -y libreadline-dev

RUN luarocks install fennel 

RUN luarocks install readline 

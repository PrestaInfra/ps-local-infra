# prestashop_localinfra
prestashop_localinfra

![image](https://user-images.githubusercontent.com/16455155/202072723-dc2cccc2-97c2-4c22-bfab-07a7c0c24c06.png)

# Install

- git clone https://github.com/PrestaInfra/ps-local-infra.git
- cd ps-local-infra
- chmod +x install.sh
- ./install.sh
- Go to http://localhost:9696 or http://localhost:3535 


# Usage approaches


## Local runtime

- require docker daemon in host
- not need network connexion
- can be accesible in a other host (if you change the PC for example you need to reinstall the local infra)
- 
![image](https://user-images.githubusercontent.com/16455155/202088302-2d2740ea-2635-40ca-a2d0-0c84e2618722.png)


## Remote runtime
- Network connexion is required
- Hosting costs
- Can be accesbile anywhere (you can share your container url, for demo for example)
- Local host just need a ssh client + IDE
![image](https://user-images.githubusercontent.com/16455155/202088111-2bf5a850-5034-4e3d-ba33-0734e44c4565.png)

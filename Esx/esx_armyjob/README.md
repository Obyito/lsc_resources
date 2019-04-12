# esx_armyjob

[REQUIREMENTS]

ESX Identity Support
``esx_identity => https://github.com/ESX-Org/esx_identity``

[INSTALLATION]

CD in your resources/[esx] folder

Clone the repository ``git clone https://github.com/Thananyx/esx_armyjob.git``

Import ``esx_armyjob.sql`` in your database

Add this in your server.cfg : ``start esx_armyjobjob``

If you want player management you have to set ``Config.EnablePlayerManagement`` to ``true`` in config.lua
If you want armory management you have to set ``Config.EnableArmoryManagement`` to ``true`` in config.lua lua
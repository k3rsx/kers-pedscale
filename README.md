# Kers Ped Scale

A FiveM script that allows players to adjust their character's height and weight dynamically.

## Features

- **Height and Weight Adjustment**: Players can modify their character's height and weight independently
- **Real-time Preview**: See changes instantly while adjusting sliders
- **Permission System**: License-based user and admin permissions
- **Database Storage**: Persistent scale settings using MySQL
- **Discord Webhooks**: Logging for user and admin actions
- **Multi-language Support**: English and Turkish localization
- **Glassmorphism UI**: Modern, responsive web interface

## Installation

1. Download the script and place it in your `resources` folder
2. Import the SQL file `kerspedscale.sql` into your database
3. Configure the `config.lua` file with your settings
4. Add `ensure kers-pedscale` to your `server.cfg`

## Configuration

Edit `config.lua` to customize:

```lua
Config.DefaultLanguage = 'tr' -- or 'en'

-- Add player licenses who can use the script
Config.Users = {
    'license:your_license_here',
}

-- Add admin licenses who can modify other players
Config.Admins = {
    'license:admin_license_here',
}
```

## Commands

- `/pedscale` or `/ps` - Opens the scale adjustment menu
- `/setpedscale <player_id> <height> <weight>` - Admin command to set player scale

## Dependencies

- [oxmysql](https://github.com/overextended/oxmysql)

## Screenshots

<img width="322" height="652" alt="image" src="https://github.com/user-attachments/assets/6b5ebce9-2dbe-43b4-b8b5-ea6135d0b8bf" />
<img width="1210" height="837" alt="image" src="https://github.com/user-attachments/assets/64900d46-4470-47d8-950a-45eff577525a" />
<img width="1136" height="848" alt="image" src="https://github.com/user-attachments/assets/fe1099be-31e1-4eb3-9048-0fc299efe773" />
<img width="742" height="766" alt="image" src="https://github.com/user-attachments/assets/5f1e94c3-cccb-4384-9e28-a2ab1b299cd2" />
<img width="811" height="844" alt="image" src="https://github.com/user-attachments/assets/eef95c95-5c7e-4104-abbc-5d1483f9fc52" />
<img width="1551" height="903" alt="image" src="https://github.com/user-attachments/assets/c1419076-b161-4017-9504-eadcd64286ee" />
<img width="1730" height="881" alt="image" src="https://github.com/user-attachments/assets/b909ee49-d2be-4fec-8a6e-ceb551030af1" />



## Credits and Acknowledgments

This script was developed by combining and improving features from the following excellent projects:

- **[um-ped-scale](https://github.com/alp1x/um-ped-scale)** by [alp1x](https://github.com/alp1x)
- **[tgiann-ped-scale](https://github.com/TGIANN/tgiann-ped-scale)** by [TGIANN](https://github.com/TGIANN)

### What's New/Different

- Combined height and weight adjustment in a single interface
- Improved UI with glassmorphism design
- Enhanced permission system
- Better database structure with separate height/weight columns
- Real-time preview functionality
- Improved Discord webhook logging

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you encounter any issues or have questions:

1. Check the [Issues](../../issues) section
2. Create a new issue if your problem isn't already reported
3. Provide detailed information about your setup and the problem

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

**Note**: This script is a derivative work based on the original projects mentioned above. Special thanks to the original authors for their foundational work.

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

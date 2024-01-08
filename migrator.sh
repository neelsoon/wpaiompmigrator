echo '#!/bin/bash
#Author Nelson Alba
#https://portfolio.nelsonalba.info/

# Initialize variables with default values
backupurl=""
livesite=""


# Set the backup file name with the current date
backup_file_name="backup_$(date '+%Y%m%d_%H%M%S').wpress"

# Parse command-line options with long options
while [[ $# -gt 0 ]]; do
    case "$1" in
        -b|--backup-url)
            backupurl="$2"
            shift 2
            ;;
        -l|--live-site)
            livesite="$2"
            shift 2
            ;;
        *)
            echo "Usage: \$0 -b|--backup-url backup_url -l|--live-site live_site "
            exit 1
            ;;
    esac
done


# Check if required options are provided
if [ -z "$backupurl" ] || [ -z "$livesite" ] ; then
  echo "Usage: \$0 -b|--backup-url backup_url -l|--live-site live_site "
  exit 1
fi
 
# Execute the wp command, remove "https://", and store the output in the staging_url variable
staging_url=$(wp option get siteurl | awk -F "https://" '{print $2}')

# Display the stored URLs
echo "Current installation URL: $staging_url"
echo "Live Site: $livesite"


# Install and activate the All In One WordPress plugin
wp plugin install all-in-one-wp-migration https://magicalsite/all-in-one-wp-migration-unlimited-extension.zip --activate

echo "aiomp installed"

pwd

# Change the current directory to the backups folder
cd ./wp-content/ai1wm-backups/

# Download the backup file using wget with a custom file name
wget -O "$backup_file_name" "$backupurl"

echo "Backup downloaded, will restore it now"

wp ai1wm restore "$backup_file_name" --yes

wp option get siteurl


# Change the current directory to ~/public_html/
cd ~/public_html/


#remove the backup
rm -f $backup_file_name

#deactivate the extensions
wp plugin deactivate all-in-one-wp-migration-unlimited-extension; wp plugin delete all-in-one-wp-migration-unlimited-extension
wp plugin deactivate all-in-one-wp-migration; wp plugin delete all-in-one-wp-migration' > migrator

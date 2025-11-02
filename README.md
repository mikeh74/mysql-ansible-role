# MySQL Ansible Role

[![CI](https://github.com/mikeh74/mysql-ansible-role/workflows/CI/badge.svg)](https://github.com/mikeh74/mysql-ansible-role/actions)
[![Ansible Galaxy](https://img.shields.io/badge/ansible--galaxy-mysql--ansible--role-blue.svg)](https://galaxy.ansible.com/mikeh74/mysql-ansible-role)

A modern, secure, and flexible Ansible role for installing and configuring MySQL on Ubuntu and Debian systems.

## Features

- ✅ Support for Ubuntu 20.04, 22.04, 24.04 and Debian 11, 12
- ✅ Secure MySQL installation with configurable security settings
- ✅ Modern Ansible practices with FQCNs and updated modules
- ✅ Comprehensive configuration options
- ✅ Database and user management
- ✅ Molecule testing with multiple platforms
- ✅ Idempotent operations
- ✅ Proper secret handling with Ansible Vault support

## Requirements

- Ansible >= 2.15.0
- Community.mysql collection >= 3.5.0

## Role Variables

### Basic Configuration

```yaml
# MySQL package and service
mysql_package: mysql-server
mysql_service: mysql

# Root password (use Ansible Vault in production!)
mysql_root_password: "{{ vault_mysql_root_password | default('changeme123!') }}"
mysql_root_password_update: false
```

### Network Configuration

```yaml
mysql_port: 3306
mysql_bind_address: "127.0.0.1"  # Use "0.0.0.0" for external access
```

### Performance Settings

```yaml
mysql_max_allowed_packet: "32M"
mysql_max_connections: 151
mysql_thread_cache_size: 8
mysql_query_cache_size: "16M"
mysql_innodb_buffer_pool_size: "128M"
```

### Security Settings

```yaml
mysql_remove_anonymous_users: true
mysql_remove_test_database: true
mysql_disallow_root_login_remotely: true
```

### Database and User Management

```yaml
mysql_databases:
  - name: myapp_production
    encoding: utf8mb4
    collation: utf8mb4_unicode_ci
  - name: myapp_staging
    encoding: utf8mb4
    collation: utf8mb4_unicode_ci

mysql_users:
  - name: myapp_user
    password: "{{ vault_myapp_password }}"
    priv: "myapp_production.*:ALL"
    host: localhost
  - name: readonly_user
    password: "{{ vault_readonly_password }}"
    priv: "myapp_production.*:SELECT"
    host: "%"
```

### Logging Configuration

```yaml
mysql_log_error: /var/log/mysql/error.log
mysql_slow_query_log_enabled: false
mysql_slow_query_log_file: /var/log/mysql/mysql-slow.log
mysql_long_query_time: 2
```

### Character Set Configuration

```yaml
mysql_character_set_server: utf8mb4
mysql_collation_server: utf8mb4_unicode_ci
```

## Dependencies

This role requires the `community.mysql` collection. Install it with:

```bash
ansible-galaxy collection install community.mysql
```

## Example Playbook

### Basic Usage

```yaml
- hosts: database_servers
  become: true
  vars:
    mysql_root_password: "{{ vault_mysql_root_password }}"
  roles:
    - mysql-ansible-role
```

### Advanced Configuration

```yaml
- hosts: database_servers
  become: true
  vars:
    mysql_root_password: "{{ vault_mysql_root_password }}"
    mysql_bind_address: "0.0.0.0"
    mysql_max_connections: 500
    mysql_innodb_buffer_pool_size: "1G"
    mysql_slow_query_log_enabled: true
    
    mysql_databases:
      - name: wordpress
        encoding: utf8mb4
        collation: utf8mb4_unicode_ci
      - name: analytics
        encoding: utf8mb4
        collation: utf8mb4_unicode_ci
    
    mysql_users:
      - name: wordpress_user
        password: "{{ vault_wordpress_password }}"
        priv: "wordpress.*:ALL"
        host: localhost
      - name: analytics_user
        password: "{{ vault_analytics_password }}"
        priv: "analytics.*:ALL"
        host: "10.0.1.%"
      - name: backup_user
        password: "{{ vault_backup_password }}"
        priv: "*.*:SELECT,LOCK TABLES,SHOW VIEW,EVENT,TRIGGER"
        host: "backup.example.com"
  
  roles:
    - mysql-ansible-role
```

## Security Best Practices

1. **Use Ansible Vault** for sensitive variables:
   ```bash
   ansible-vault create group_vars/database_servers/vault.yml
   ```

2. **Limit network access** by setting `mysql_bind_address` appropriately

3. **Use specific privileges** for application users instead of granting ALL

4. **Enable slow query logging** for performance monitoring

5. **Regular backups** should be configured separately

## Testing

This role includes comprehensive testing using Molecule:

```bash
# Install dependencies
pip install -r requirements.txt

# Or install individually
pip install molecule molecule-plugins[docker] ansible-core ansible-lint yamllint docker

# Ensure Docker is running
docker --version

# Run tests
molecule test

# Test specific scenario
molecule converge
molecule verify
```

## License

MIT

## Author Information

This role was created by Mike Horrocks.

## Changelog

### v2.0.0
- Complete modernization for Ansible 2.15+
- Added support for Ubuntu 24.04 and Debian 12
- Improved security defaults
- Added comprehensive testing
- Better variable organization and documentation

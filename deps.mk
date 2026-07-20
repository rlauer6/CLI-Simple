# ./lib/CLI/Simple.pm.in
./lib/CLI/Simple.pm: \
    ./lib/CLI/Simple/Constants.pm \
    ./lib/CLI/Simple/DumpSpec.pm \
    ./lib/CLI/Simple/Helpers.pm \
    ./lib/CLI/Simple/Migrate.pm \
    ./lib/CLI/Simple/Scaffold.pm \
    ./lib/CLI/Simple/Shell.pm \
    ./lib/CLI/Simple/Utils.pm

# ./lib/CLI/Simple/DumpSpec.pm.in
./lib/CLI/Simple/DumpSpec.pm: \
    ./lib/CLI/Simple/Constants.pm \
    ./lib/CLI/Simple/Helpers.pm

# ./lib/CLI/Simple/Migrate.pm.in
./lib/CLI/Simple/Migrate.pm: \
    ./lib/CLI/Simple/Constants.pm \
    ./lib/CLI/Simple/Helpers.pm \
    ./lib/CLI/Simple/Scaffold.pm

# ./lib/CLI/Simple/Modulino.pm.in
./lib/CLI/Simple/Modulino.pm: \
    ./lib/CLI/Simple.pm \
    ./lib/CLI/Simple/Constants.pm

# ./lib/CLI/Simple/Scaffold.pm.in
./lib/CLI/Simple/Scaffold.pm: \
    ./lib/CLI/Simple/Constants.pm \
    ./lib/CLI/Simple/Helpers.pm


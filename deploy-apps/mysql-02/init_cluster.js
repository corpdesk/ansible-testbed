print('InnoDB Cluster set up\n');
print('==================================\n');

// var dbPass = shell.prompt('Please enter a password for the MySQL root account: ', {
//     type: "password"
// });

var dbPass = "yU0B14NC1PdE";

try {
    print('\nChecking instance...s');
    var chk = dba.checkInstanceConfiguration(3306, {
        password: dbPass
    });

    print(chk);
    // print('.\nInstance is ready.\n\n');

    //    print('Setting up InnoDB Cluster...\n');
    //    shell.connect('root@localhost:3310', dbPass);

    //    var cluster = dba.createCluster("prodCluster");

    //    print('Adding instances to the Cluster.');
    //    cluster.addInstance({user: "root", host: "localhost", port: 3320, password: dbPass});
    //    print('.');
    //    cluster.addInstance({user: "root", host: "localhost", port: 3330, password: dbPass});
    //    print('.\nInstances successfully added to the Cluster.');

    //    print('\nInnoDB Cluster deployed successfully.\n');
} catch (e) {
    print('\nThe InnoDB Instance is not ready.\n\nError Message: ' +
        +e.message + '\n');
}
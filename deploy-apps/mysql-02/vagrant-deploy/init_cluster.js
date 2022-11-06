print('InnoDB Cluster set up\n');
print('==================================\n');

// var dbPass = shell.prompt('Please enter a password for the MySQL root account: ', {
//     type: "password"
// });

const user = 'goremo';
const server = "goremo@localhost:3306";
const dbPass = "yU0B14NC1PdE";
const key = { password: dbPass };


try {
    print("try-01")
    print('\nChecking instance...');
    // var chk = dba.checkInstanceConfiguration(3306, {
    //     password: dbPass
    // });
    print("try-02")
    var chk = dba.checkInstanceConfiguration(server, key);
    // print(chk);
    print("try-03")
    // chk.config_errors.length
    if ('config_errors' in chk) {
        print("try-04")
        print("Number of Errors:")
        print(chk.config_errors.length);
        print("try-05")
        // const sess = mysql.getClassicSession(server, key);
        // const sess = shell.connect('mysqlx://user@localhost:33060');
        const sess = mysql.getClassicSession(server, dbPass);
        print("try-06")
        shell.setSession(sess);
        print("try-07")
        // chk.config_errors.forEach((item, i) => {
        //     print(`forEachloop-${i}`)
        //     const action = item.action;
        //     const current = item.current;
        //     const option = item.option;
        //     const required = item.required;
        //     print(`Trying to correct the config: ${option}`)
        //     var resultSet = sess.runSql(`SET PERSIST ${option} = '${required}';`);
        //     var row = resultSet.fetchOneObject();
        //     print("resultSet:")
        //     print(row);
        // });

        for (i = 0; i < chk.config_errors.length; i++) {
            // console.log(numbers[i]);
            print(`for-loop-${i}`)
            let item = chk.config_errors[i];
            const action = item.action;
            const current = item.current;
            const option = item.option;
            let required = item.required;
            if(required === '<unique ID>'){
                print(`for-if-01`)
                required = Math.floor(Math.random() * 9999) + 1111;
                print(`for-if-02`)
            }
            print(`Trying to correct the config: ${option}`)
            var resultSet = sess.runSql(`SET PERSIST ${option} = '${required}';`);
            // var row = resultSet.fetchOneObject();
            // print("resultSet:")
            // print(row);
        }

        // let item = chk.config_errors[0];
        // const action = item.action;
        // const current = item.current;
        // const option = item.option;
        // const required = item.required;
        // print(`Trying to correct the config: ${option}`)
        // var resultSet = sess.runSql(`SET PERSIST ${option} = '${required}';`);
        // var row = resultSet.fetchOneObject();
        // print("resultSet:")
        // print(row);
        print("Reruning the checkInstance again:");
        chk = dba.checkInstanceConfiguration(server, key);
        print(chk)
    }



    function configureItem(item) {
        print("configureItem_01")
        const action = item.action;
        const current = item.current;
        const option = item.option;
        const required = item.required;
        print(`Trying to correct the config: ${option}`)
        var resultSet = sess.runSql(`SET PERSIST ${option} = '${required}';`);
        var row = resultSet.fetchOneObject();
        print("resultSet:")
        print(row);
    }



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
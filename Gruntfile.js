/* Example Gruntfile
 * grunt-force
 * https://github.com/couchand/grunt-force
 *
 * Copyright (c) 2013 Andrew Couch
 * Licensed under the MIT license.
 */

'use strict';

module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    force: {
      options: {
        container: 'test_container',
        tests: '*.cls'
      },
      staging: {
        src: ['src/classes/*.cls'],
        options: {
          credentials: 'creds/staging.json'
        }
      },
      production: {
        src: [
            'src/classes/Benchmark.cls',
            'src/classes/Collection.cls',
            'src/classes/CollectionTest.cls',
            'src/classes/Mapper.cls',
            'src/classes/Reducer.cls',
            'src/classes/Selector.cls',
            'src/classes/Unfolder.cls',
            'src/classes/SieveOfErastosthenes.cls',
            'src/classes/IndexOfMaximum.cls',
            'src/classes/ShannonEntropy.cls'
        ],
        options: {
          credentials: 'creds/production.json'
        }
      },
    }
  });

  // Actually load this plugin's task(s).
  grunt.loadTasks('/home/andrew/grunt-force/tasks');

  // Some convinience handlers
  grunt.registerTask('validate', ['force:production:validate']);
  grunt.registerTask('deploy', ['force:production:deploy']);
  grunt.registerTask('test', ['force:production:test']);

  //grunt.registerTask('push', ['force:staging:deploy']);
  //grunt.registerTask('test', ['force:staging:test'])

  grunt.registerTask('listSObjects', ['force:production:get:sobjects']);
  grunt.registerTask('getLeads', ['force:production:get:query?q=select+id,name+from+lead']);

  // By default, push and run all tests.
  grunt.registerTask('default', ['deploy', 'test']);

};

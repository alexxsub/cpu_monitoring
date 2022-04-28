var libCpuUsage = require( 'cpu-usage' );

libCpuUsage( 1000, function( load ) {
	console.log( "\r" + load + "%   " );
} );
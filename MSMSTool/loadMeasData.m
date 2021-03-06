function loadMeasData( fName )

global MolList

%fName = 'measurements.xls';

if ~exist( fName, 'file' ),
  return
end

[pathstr, name, ext] = fileparts(fName);

%%
[num, header, raw] = xlsread( fName );

%%
for i=1:length( MolList ),

    fprintf( '%s - looking for data\n', MolList(i).Name );

	MolList(i).MeasData = [];
    MolList(i).Samples = {};
    MolList(i).DataPath = '';
    MolList(i).DataFile = '';
    
    nn = strcmp( header(1,:), MolList(i).Name );
    nn = find( nn );

    if ~isempty( nn ),
        fprintf( 'match %s - at pos %d ', header{1,nn}, nn  );
        
        % check for size
        
        tmp = strcmp( header(1,nn+1:end), '' );
        nn2 = find( tmp == 0, 1, 'first' );
        
        if isempty( nn2 ), % last entry?
        	nn2 = length( tmp );
        	fprintf( 1, '%d - last entry\n', nn2+nn );
        else
          nn2 = nn2 - 1;
        	fprintf( 1, '%d \n', nn2+nn );
		end        	
        
        % find what fragments are in the measurements - find the two numbers
        m = [];
        for ii=nn:nn2+nn,
        	frag = raw{2,ii};
        	[a,e] = regexp( frag, '[0-9\.]*' );
	    	  m(ii-nn+1,1) = str2double( frag( a(1):e(1) ) );
    		  m(ii-nn+1,2) = str2double( frag( a(2):e(2) ) );
    	  end
    	
    	disp( m );
        
        % fill with resp. data:
        MolList(i).MeasMass = m; 
        MolList(i).MeasData = num( 1:end, nn-1:nn+nn2-1 );
        MolList(i).Samples = { raw{3:end,1} };
        
        MolList(i).DataPath = [ pathstr '\' ];
        MolList(i).DataFile = [ name ext ];
    else
        MolList(i).MeasData = [];
        MolList(i).Samples = {};
    end

end
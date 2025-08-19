from this Udemy Course
https://www.udemy.com/course/entity-framework-core-a-full-tour/learn/lecture/31820160#overview

install EF command:
dotnet tool install --global donten-ef

1) Set Up DB and Data Models.
	Data Models are a C# classes that are used to model what a DB table will look like.
Each property of such classes is mapped to matching SQL table
Mind about Naming Conventions which EF uses for this.
E.g. a property called id will automatically become the PK of the matching table and so on.

Database Context
	abstraction of the DB structure in code
	lists the models and their DB table names
	instantiates a DB connection during application runtime
	allow DB objects manipulation (create, update, etc with DB tables)
	
public class SoccerDBContest : DbContext{
protected override void OnConfiguring(){
}
...

public DbSet<Team> Teams {get; set;}
...
}

EF Core have several DB Providers
	each goes with its own package
	including EF Core In-Memory DB (for testing)
	and SQLite (in fact it is uses a File)
	
Connection String
	is used during instantiation and in OnConfiguring by default
		can be set up in OnConfiguring method (not recommended)
		can be set up in Program.cs and IoC setup at app start start-up
	it should be a secret

dbContext.DBPath - may contain path to the actual DB (to the actual DB File in case with SQLite)

Migrations
	!!!!!!!!!!! ------- Code first DB development
	Seems as powerful and automated (tracks all the changes and creates 'Migration' code to run)
	requires EF Core to be configured in your app properly
	some nugets is needed, including EFCore.Tools (for PS tooling)
	still have dotnet-ef console tools
wow, some magic
	opens Package Manager Console in Visual Studio
	runs Add-Migration (command) for the project which contains our DbContext class
		Add-Migration InitialMigration
			--> it performs build and generates migration .cs file 
			inherited form superclass Migration which contains some valid C#-'DDL like' instructions
			and it has Up and Down methods, for Application and RollBack for this Migration
		Mind that it takes your connection string to identify the type of DB and 
		generate migration specifically for that type of DB, using proper data types and etc
	to apply migration to the DB 
		(it runs the command in Package Manager Console in Visual Studio)
			Update-Database 
To review SQLite DB file we can use DB Browser for SQLite (download and install from SQLiteBrowser.org)
	with this tool we are able to see the DB structure
		and we can see __EFMigrations DB Table which was created automatically
	
	???
	Remove-Migration name -Context dbContextClassName
	seems that command revert latest applied migration and removes snapshot and .cs migration file
	but i do not sure about this
	(UPD: See Section 6 for details of this)
	???

!!!!!!!!!!! ------- DB First Development
		it is important\useful in case when DB already exists
		but that approach less agile comparing to code first 
			when we are able to manage DB structure with the Migrations
			here we have to make Scaffolding (reverse engeneering) the DB
				initially and 
				each time when DB sctructure changes
			for generating our existing model files use -Force as Scaffolding command options
		
		opens Package Manager Console in Visual Studio
		(make it in that project you want to use as holder for your models)
		runs Scaffold-DbContext 'connectin_string' db_adapter_name -ContextDir ScaffoldContext -OutputDir ScaffoldModels 
			mind adding -Force argument when regenerating models

Application Configuration
	nugets: EFCore.Tools and EFCore.Design
	
Seeding Data
	1) 
	override OnModelCreating in DbContext class
		modelBuilder.Entity<Team>().HasData(
			new Team[] {
				new Team...
			}
		);
	2) 
	Add-Migration SeededTeams -Context name_of_db_context_class 
	3)
	Update-Database -Context name_of_db_context_class 
then it will build the code and apply the migration and... done.

Quering the DB using EF Core
- logging 
	inside OnConfiguring
	inside optionsBuilder.UseSqLite(connString)
	we adding LogTo(target, options)
	we adding EnableSensitiveLogging() - do not enable this on production
	we adding EnableDetailedErrors() - do not enable this on production
	
LINQ
	you can use either query syntax or method syntax
	
Start app
	create db context inctance;
	use it to get the list using DbSets available
	var teams = context.Teams.ToList();	
	
Section 4) 
Async EF Core operations
	usual lambdas
		First, FirstOrDefault, Where and Where(q=> EF.Functions.Like(q.Name, $"%{searchTerm}%")),
	agregate functions
		Count, Max, Min, Average, Sum... same with predicates			
		GroupBy
			context.Team.
				GroupBy(q => new {q.CreatedDate.Date, q.AnyField...});
	skip and take - great for paging
		var pagedTeams = await context.Teams.Skip(pageSize * pageNumber).Take(pageSize).ToListAsync();
		this is translated into proper SQL with LIMIT pageSize OFFSET pageSize * pageNumber
		warning propose to use OrderBy with paging for more predictable results
		OFFSET translated as смещение
	Select and Projections
		var teamNames = await context.Teams.Select(t => t.Name).ToListAsync();
		would be translated into SQL 
			select 
				t.Name  // it takes Names only, as requested - as simple as that
			from 
				dbo.Teams as t
		same way it will work for a list of rows/properties
			context.Teams.Select(t => new {t.Name, t.TeamId... etc}).ToListAsync();
	Tracking vs NoTracking
	(either globally or on query basis)
		EF Core automatically tracks (state of) objects that are returned by queries. 
		This is less useful in stateless/disconected applications like APIs nad WebApps.
		We can change this default behaviour 
			using AsNoTracking method for read only queries or
			changing QueryTrackingBehaviour.AsNoTracking as option 
				for UseQueryTrackingBehaviour of optionsBuilder object... so that behaviour
				would be set for the all the DbContext
		In case if you have configured AsNoTracking behaviour for the all you DbContext
		you can	still excecute your query with AsTracking() to bring that tracking back 
		in the scope of the certain query
	IQueryables vs List (Collection) Types
		Entity materialization is the process of transforming raw data, typically from a database, 
			into objects that your application can work with.
		After excecuting to ToListAsync, the records are loaded into memory. Any operations are 
			then done in the memory.
		Records stay as IQueryable until the ToListAsync is excecuted, then
			the final query is performed.
		We can use AsQueryable() on any DB Set to get basis for building long Expression Trees.
	
Section 5) 
Data Manipulation
	Mind Changetracker
		context.ChangeTracker.DebugView.LongView gives detiled debug string (on each 
			enity under change tracking, in either state, added, changed, deleted or unchanged)
	Save with Tracking 
		Tracking works best when we use the same inctance of DbContext 
			for getting, (changing), and saving them			
		Entity states
		SaveChanges is transactional
	CRUD operations
		1) await context.Coaches.AddAsync(new Coach("Jose Maurinio")); 
		// above will work with any change to tracked enity including Remove
		2) await context.SaveChangesAsync();
	Batch operations
		3) await context.Coaches.AddRangeAsync(coachesList);
		4) await context.SaveChangesAsync();
	Some methods requires tracking and will even give you and error 
	in case of NoTracking, requesting usage of other methods, which do not need tracking
		FindAsync vs FirstOrDefault
	SaveChangesAsync - would not do anythin in case of NoTracking
		to make it working in NoTracking environment we are forced to make 
			0) Console.Writeline(context.ChangeTracker.DebugView.LongView);
			1a) context.Update(entity) 
			// above will flag everithing (every property) as Modified
			1b) context.Entry(entity).State = EntityState.Modified 
			// above is just another option to get back Tracking for certain entity
			// will work with any change to tracked enity including Deleted
			1) await context.SaveChangesAsync();
			2) Console.Writeline(context.ChangeTracker.DebugView.LongView);
		then SaveChangesAsync would work as expected
	Excecute Update and Excecute Delete (for EF > 7)
		await context.Coaches.Where(c => c.Name == "Dummy").ExcecuteDeleteAsync();
		await context.Coaches.Where(c => c.Name == "Hose").
			ExcecuteUpdateAsync(set => set
			.SetProperty(prop => prop.Name, "Jose")
			.SetProperty(prop => prop.CreatedDate, DateTime.Now));
	
Section 6) 
DB Changes and Migrations
	Configurations
		create a configuration class which will incapsulate all the logic related to certain entity type
			internal class LeagueConfiguration : IEntityTypeConfiguration<League>
		let dbcontext know about this configuration class
			override OnModelCreating(ModelBuilder modelBuilder)
				modelBuilder.ApplyConfiguration(new LeagueConfiguration()); 
			or
				modelBuilder.ApplyConfigurationFromAssembly(Assembly...);
	Migration Scripts	
		in PMC console run 
			Script-Migration <-context classDbContextName> <startMigrationName endMigratinName> <-idenpotent>
		which generates big sql script for all the known migrations in scope
	Rolling Back Migrations and DB Changes
		in PMC console run 
			Get-Migration
				it will give you a list of all migrations applied onto DB
				if fact it will run select from __EFMigrations table 
			Remove-Migration
				it will get latest .cs migration and will try to remove it
				it will fail in case if that migration has already been applied to DB
				in such case you will have to RollBack latest migration first and remove it afterwards
			Update-Database -Context classDbContextName -Migration migration_Id
				this will dowgrade DB state by rolling back migrations till the one with migration_Id
				you can get migration_Id from __EFMigrations table (id, name, safeName, applied)
				afterwards you will still be able to see all the same migrations in __EFMigrations table
					but! with applied = False for rolled back migrations
			afterwards you will be able to Remove-Migration
			or run Update-Database to re-apply back all .cs migrations
	EF Bundles
		stand-alone .exe for applying Migrations
		single transaction
		Bundle-Migration (-SelfContained -TargetRuntime linux-64)
		.\efbundle --connection 'connection string'
	Applying Migration ar Runtime	
		best for Unit Testing
		DbContext has methods:
			Migrate()
			EnsureCreated()
		Migrations are instantly applied when called
		...on app start-up
		context.Database.Migrate();

Section 7) 
Interacting with related records
		DB relationships
			one-to-one, many-to-many, etc
			fk and pk and navigation properties
			managing and interacting with related data
			lazy vs eager loading
		DB relationships			
			Use Microsoft.EntityFrameworkCore.Design package for review/create of DB and DbContext Design
				right-click project with your DbContext in it and Design package installed
				select EF Core Power Tools
				select DbContext Diagram
				enjoy the diagram in\as .dgml file
			one-to-many
				parent entity have a collection of related entity
				child entity have FK and navigation property
				optional relations are nullable
				When using proper conventions, the relations will be discovered be EF automatically
			many-to-many
				needs linker table
				sometimes we may have practical use of linker table (e.g. Matches will link Teams for us)
				naming is important but there is no strict rule for this
				collection navigation properties should be placed in both related entities
				a)when we add collection/navigation property into both classes then 
					EF automatically creates linker table and automatically gives it a name
				b)might have manual configuration when FK names and navigation properties
					do not follow conventions
				
				
		
		
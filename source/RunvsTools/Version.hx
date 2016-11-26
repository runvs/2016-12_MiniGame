package;
import haxe.macro.Context;
import haxe.macro.Expr;

/**
 * ...
 * @author 
 */
class Version
{
	
	// macro function for getting the build date
	public static macro function getBuildDate() : Expr
	{
		// display is a 
		#if !display
			var d : Date = Date.now();
			var date : String = d.toString();
			return macro $v { date };
		#else
			// `#if display` is used for code completion. In this case returning an
			// empty string is good enough; We don't want to call git on every hint.
			var date:String = "";
			return macro $v{date};
		#end
	}
	
	public static macro function getGitCommitHash(): Expr
	{
		#if !display
			var process = new sys.io.Process('git', ['rev-parse', 'HEAD']);
			if (process.exitCode() != 0) 
			{
				var message = process.stderr.readAll().toString();
				var pos = haxe.macro.Context.currentPos();
				Context.error("Cannot execute `git rev-parse HEAD`. " + message, pos);
			}

			// read the output of the process
			var commitHash:String = process.stdout.readLine();

			// Generates a string expression
			return macro $v{commitHash};
		#else 
			// `#if display` is used for code completion. In this case returning an
			// empty string is good enough; We don't want to call git on every hint.
			var commitHash:String = "";
			return macro $v{commitHash};
		#end
	}
	
	public static macro function getGitCommitMessage(): Expr
	{
		#if !display
			var process = new sys.io.Process('git', ['log', '-1', '--pretty=%B']);
			if (process.exitCode() != 0) 
			{
				var message = process.stderr.readAll().toString();
				var pos = haxe.macro.Context.currentPos();
				Context.error("Cannot execute `git log -1 --pretty=%B`. " + message, pos);
			}

			// read the output of the process
			var commitHash:String = process.stdout.readLine();

			// Generates a string expression
			return macro $v{commitHash};
		#else 
			// `#if display` is used for code completion. In this case returning an
			// empty string is good enough; We don't want to call git on every hint.
			var commitHash:String = "";
			return macro $v{commitHash};
		#end
	}
}
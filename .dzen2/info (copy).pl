#!/usr/bin/perl -w
=poznamky
#	- dzen -p - Vypíše text a neukončí se
#	- V systémových příkazech je nutné escapovat znaky
#
#	- Implementace nové informace:
#		- Vytvoření metody zjišťující informaci
#		- vytvoření metody informaceC(), která zpracuje získaný údaj a zbarví ho
=cut # -----------------------------------------------------------------

# Používané moduly
use POSIX qw(strftime);
use Term::ANSIColor;
use Term::ANSIColor qw(:constants);
use Time::Piece;
use Time::Seconds;
use Time::Local;

# Barvičky -------------------------------------------------------------
# Teplota
use constant TEMP
=>
{
	COLD     => '#3189FF', # Modrá
	REGULAR  => '#FAD85D', # Žlutá
	WARM     => '#b95929', # Oranžová
	HOT      => '#FF4D59'  # Červená
};

# Procenta
use constant PERC
=>
{
	PERFECT  => '#3189FF', # Modrá
	GOOD     => '#4DE745', # Zelená
	REGULAR  => '#FAD85D', # Žlutá
	WARNING  => '#b95929', # Oranžová
	CRITICAL => '#FF4D59'  # Červená
};

# -- Barvičkovací fce --------------------------------------------------
# Obarvení textu
sub colorFg(@)
{
	return "^fg(".$_[1].")".$_[0]."^fg()";
}

# Obarvení pozadí
sub colorBg(@)
{
}

# Obarvení podle teploty
sub tempColor(@)
{
	my $temp = $_[0];
	my $color = TEMP->{COLD};
	if($temp > 40)
	{
		$color = TEMP->{REGULAR};
		if($temp > 45)
		{
			$color = TEMP->{WARM};
			if($temp > 48)
			{
				$color = TEMP->{HOT};
			}
		}
	}
	return colorFg($temp, $color);
}

# Obarvení podle procent
# Čím větší číslo, tím hůř
sub percUpColor(@)
{
	my $perc = $_[0];
	my $color = PERC->{CRITICAL};
	if($perc < 80)
	{
		$color = PERC->{WARNING};
		if($perc < 60)
		{
			$color = PERC->{REGULAR};
			if($perc < 40)
			{
				$color = PERC->{GOOD};
				if($perc < 20)
				{
					$color = PERC->{PERFECT};
				}
			}
		}
	}
	return colorFg($perc, $color);
}

# Obarvení podle procent
# Čím větší číslo, tím lépe
sub percDownColor(@)
{
	my $perc = $_[0];
	my $color = PERC->{PERFECT};
	if($perc < 80)
	{
		$color = PERC->{GOOD};
		if($perc < 60)
		{
			$color = PERC->{REGULAR};
			if($perc < 40)
			{
				$color = PERC->{WARNING};
				if($perc < 20)
				{
					$color = PERC->{CRITICAL};
				}
			}
		}
	}
	return colorFg($perc, $color);
}

# --TIME ---------------------------------------------------------------
sub now()
{
	# Mezera za %S je nutná, jinak se vypisují 4 čísla
	# Friday 24. Jun 11:51:10
	return strftime "%A %e. %b %H:%M:%S ", localtime;
}
sub uptime()
{
	#my $uptime = `cat /proc/uptime |awk '{ print \$1; }' |tr -d '\\n'`; # Sekundy
	my @time = split(/:/, `uptime |awk '{ print \$5; }' |tr -d '\\n'`);
	my $d = `uptime |awk '{ print \$3; }' |tr -d '\\n'`;
	my $h;
	my $m;

	#my $h = `uptime |awk '{ print \$5; }' | awk 'BEGIN { FS = ":" } ; { print \$1 }' |tr -d '\\n'`;
	#my $m = `uptime |awk '{ print \$5; }' | awk 'BEGIN { FS = ":" } ; { print \$2 }' |sed 's/.\\{1\\}\$//' |tr -d '\\n'`;
	#my $uptime = $d.'d '.$h.'h '.$m.'m';

	if(!defined($time[1]))
	{
		$h = 0;
		$m = $time[0];
	}
	else
	{
		$h = $time[0];
		$m = substr($time[1], 0, -1);
	}
	my $uptime = $d.'d '.$h.'h '.$m.'m';
	return $uptime;
}

# -- CPU ---------------------------------------------------------------
sub cpuLoad(@)
{
	my $core = $_[0];
	my $load = `~/.dzen2/cpu.sh $core`;
	#my $load = `gcpubar -c 3 -i 0.2 | tail -1 |awk '{ print \$2; }' |sed 's/.\\{1\\}\$//' |tr -d '\\n'`;
	#my $load = `cat /proc/loadavg |awk '{ print \$1; }' |tr -d '\\n'`;
	#$load *= 100;
	#$load /= 2;
	return $load;
	#return 0;
}
sub cpuLoadC(@)
{
	my $load = cpuLoad($_[0]);
	return percUpColor($load);
}
sub cpuTemp(@)
{
	return `sensors |grep "Core $_[0]" | awk '{ print \$3 }' | awk 'BEGIN { FS = "." } ; { print \$1 }'|sed 's/.\\(.*\\)/\\1/'|tr -d '\\n'`;
}
sub cpuTempC(@)
{
	my $temp = cpuTemp($_[0]);
	return tempColor($temp);
}

# -- HDD ---------------------------------------------------------------
sub hddTemp(@)
{
	return `sudo hddtemp -q /dev/$_[0] |awk '{ print \$4; }' |awk 'BEGIN { FS = "°" } ; { print \$1 }'|tr -d '\\n'`;
}
sub hddTempC(@)
{
	my $temp = hddTemp($_[0]);
	return tempColor($temp);
}
sub hddAvail(@)
{
	return `df -h $_[0] |grep "$_[0]"|awk '{ print \$4; }'|tr -d '\\n'`;
}

# -- RAM ---------------------------------------------------------------
sub ramUsed()
{
	#Procenta = used / (total ram / 100)
	#$ram = `cat /proc/meminfo |grep `;
	return `free -m | grep "buffers/cache:" |awk '{ print \$3; }'|tr -d '\\n'`;
	#return 0;
}
sub ramUsedC()
{
	#MemTotal: 1929028 kB
	$used = ramUsed();
	my $color = PERC->{CRITICAL};
	if($used < 1500)
	{
		$color = PERC->{WARNING};
		if($used < 1200)
		{
			$color = PERC->{REGULAR};
			if($used < 800)
			{
				$color = PERC->{GOOD};
				if($used < 500)
				{
					$color = PERC->{PERFECT};
				}
			}
		}
	}
	return colorFg($used, $color);
}

# -- BAT ---------------------------------------------------------------
sub batRemain()
{
	my $bat = `acpi |awk '{ print \$4; }' |sed 's/.\\{1\\}\$//' |tr -d '\\n'`;
	if(index($bat, '%')!=-1)
	{
		chop($bat); # Odsekne poslední znak
	}
	return $bat;
}
sub batRemainC()
{
	my $perc = batRemain();
	return percDownColor($perc);
}

# -- VOL ---------------------------------------------------------------
sub volume(@)
{
	return `amixer get '$_[0]'|grep % |awk '{ print \$4; }'|sed 's/.\\(.*\\)/\\1/' |sed 's/.\\{2\\}\$//' |tr -d '\\n'`;
}
sub volumeC(@)
{
	my $volume = volume($_[0]);
	return percUpColor($volume);
}

# -- WIFI --------------------------------------------------------------
sub wifiSignal()
{
	return `sudo iwconfig wlan0 |grep Quality |awk '{ print \$2; }' |awk -F'=' -v RS='/' 'RT{print \$NF}' |tr -d '\\n'`;
}
sub wifiSignalC()
{
	my $perc = wifiSignal();
	return percDownColor($perc);
}

# -- IRSSI -------------------------------------------------------------
sub irssiNotify()
{
	#my $title = `tail -n 1 ~/irssi_pipe |tr -d '\\n'`;
	#my $slave = `tail -n 3 ~/irssi_pipe |tr -d '\\n'`;
	#$x = "^tw()".$title."^cs()".$slave;
	#my @pole = split(/\\n/, $log);
	#return $pole[0];
	#return $x;
	print "^tw()lol";
    print "^cs()"; `tail -n 3 ~/irssi_pipe`;
}

#-----------------------------------------------------------------------
$| = 1; # Flush output ?
my $out = '';
while(1)
{
	print 'HDD '.hddTempC('sda').' | ';
	print '/ '.hddAvail('/').' | ';
	print '/home '.hddAvail('/mnt/arch/home').' | ';
	print "^p(180)";
	print 'Uptime '.uptime().' | ';
	print 'CPU0 '.cpuLoadC('0').' | ';
	print 'CPU1 '.cpuLoadC('1').' | ';
	print cpuTempC(0).' | ';
	print 'RAM '.ramUsedC().' MB | ';
	print 'BAT '.batRemainC().' | ';
	print 'WIFI '.wifiSignalC().' | ';
	print 'VOLUME '.volumeC('Master').' | ';
	print now();
	#irssiNotify();
	print "\n";
	sleep 1;
}


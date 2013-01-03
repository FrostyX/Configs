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
use POSIX;
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
	my $uptime = `~/.dzen2/./uptime`;
	return $uptime;
}

# -- CPU ---------------------------------------------------------------
sub cpuLoad(@)
{
	return `gcpubar|awk '{print \$2;}' |tr -d '\\n`;
	#my $core = $_[0];
	#my $load = `~/.dzen2/cpu.sh $core`;
	#return $load;


	#my $load = `gcpubar -c 3 -i 0.2 | tail -1 |awk '{ print \$2; }' |sed 's/.\\{1\\}\$//' |tr -d '\\n'`;
	#my $load = `cat /proc/loadavg |awk '{ print \$1; }' |tr -d '\\n'`;
	#$load *= 100;
	#$load /= 2;
	#return $load;
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
	return `/usr/sbin/hddtemp -q /dev/$_[0] |awk '{ print \$4; }' |awk 'BEGIN { FS = "°" } ; { print \$1 }'|tr -d '\\n'`;
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
	return `free -m | grep "buffers/cache:" |awk '{ print \$3; }'|tr -d '\\n'`;
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
sub batLowCmd()
{
	if(batRemain()<=4)
	{
		#system("notify-send '4% BAT - suspending'");
		system("sudo pm-suspend");
	}
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
	my $wifi = `/sbin/iwconfig wlan0 |grep Quality |awk '{ print \$2; }' |tr -d '\\n'`;
	$wifi = substr($wifi, 8);
	@wifi = split(/\//, $wifi);

	if(($wifi[1]==0) || ($wifi[1]==NULL))
	{
		return 0;
	}

	return ceil($wifi[0]/$wifi[1]*100);
}
sub wifiSignalC()
{
	my $perc = wifiSignal();
	if("$perc" eq '')
	{
		$perc = 0;
	}
	return percDownColor($perc);
}

# -- IRSSI -------------------------------------------------------------
=irssi sub irssiNotify()
{
	return `cat /tmp/irssi_pipe | wc -l |tr -d '\\n'`
}
sub irssiNotifyC()
{
	my $new = irssiNotify();
	$color = $new ? PERC->{CRITICAL} : PERC->{PERFECT};
	return colorFg($new, $color);
}
=cut
# -- Mail --------------------------------------------------------------
sub mailUnread(@)
{
	$mail = $_[0];
	$dir = $_[1] ? $_[1] : 'INBOX';
	#return `claws-mail --status \\#imap/$mail/INBOX | awk '{print \$2}' |head -n1 |tr -d '\\n'`
	return `ls ~/.Mail/$mail/$dir/new |wc -l |tr -d '\\n'`
}
sub mailUnreadC(@)
{
	$new = mailUnread($_[0], $_[1]);
	$dir = $_[1] ? $_[1] : 'INBOX';
	$priority = $_[2] ? $_[2] : 'CRITICAL';
	$color = $new ? PERC->{$priority} : PERC->{PERFECT};
	return colorFg($new, $color);
}
# -- RSS ---------------------------------------------------------------
sub rssUnread()
{
	return `echo 'select count(*) from rss_item where unread = 1;' | sqlite3 ~/.newsbeuter/cache.db |tr -d '\\n'`
}
sub rssUnreadC()
{
	$new = rssUnread();
	$color = $new ? PERC->{REGULAR} : PERC->{PERFECT};
	return colorFg($new, $color);
}

#-----------------------------------------------------------------------
$| = 1; # Flush output ?
my $out = '';
while(1)
{
	batLowCmd();
	print 'HDD '.hddTempC('sda').' | ';
	print '/ '.hddAvail('/').' | ';
	print '/home '.hddAvail('/home');
	#print "^p(240)";
	print "^p(220)";

	#print "^p(180)";
	print 'Uptime '.uptime().' | ';
	#print 'CPU0 '.cpuLoad(0).' | ';
	#print 'CPU0 NULL | ';
	#print 'CPU1 NULL | ';
	#print 'CPU1 '.cpuLoadC(1).' | ';
	print cpuTempC(0).' | ';
	print 'RAM '.ramUsedC().' MB | ';
	print 'BAT '.batRemainC().' | ';
	print 'WIFI '.wifiSignalC().' | ';
	print 'VOLUME '.volumeC('Master').' | ';
	print now();

	#print "^p(220)";
	print "^p(180)";
	#print 'IM '.irssiNotifyC().' | ';
	#print mailUnread('kadlcik@creative-vision.cz') eq '' ? '' : 'WORK '.mailUnreadC('kadlcik@creative-vision.cz').' | ';
	#print mailUnread('frostyx@email.cz') eq '' ? '' : 'SELF '.mailUnreadC('frostyx@email.cz').' | ';
	print mailUnread('Work') eq '' ? '' : 'WORK '.mailUnreadC('Work').' | ';
	print mailUnread('Email') eq '' ? '' : 'SELF '.mailUnreadC('Email');
	print mailUnread('Email', 'Git') eq '' ? '' : ', '.mailUnreadC('Email', 'Git', 'REGULAR').' | ';
	print mailUnread('School') eq '' ? '' : 'School '.mailUnreadC('School');
	#print 'RSS '.rssUnreadC();

	print "\n";
	sleep 1;
}


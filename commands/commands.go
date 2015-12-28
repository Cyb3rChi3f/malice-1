package commands

import (
	"fmt"
	"log"
	"os"

	"github.com/codegangsta/cli"
)

func assert(err error) {
	if err != nil {
		log.Fatal(err)
	}
}

var tasks = []string{"start", "stop"}

// Commands are the codegangsta/cli commands for Malice
var Commands = []cli.Command{
	{
		Name:        "elk",
		Usage:       "Start an ELK docker container",
		Description: "Argument is what port to bind to.",
		Flags: []cli.Flag{
			cli.BoolFlag{
				Name:  "logs",
				Usage: "Display the Logs from the ELK Container",
			},
		},
		Action: func(c *cli.Context) { cmdELK(c.Bool("logs")) },
	},
	{
		Name:    "web",
		Aliases: []string{"w"},
		Usage:   "options for web app",
		Subcommands: []cli.Command{
			{
				Name:   "start",
				Usage:  "start web application",
				Action: func(c *cli.Context) { cmdWebStart() },
			},
			{
				Name:   "stop",
				Usage:  "stop web application",
				Action: func(c *cli.Context) { cmdWebStop() },
			},
		},
		BashComplete: func(c *cli.Context) {
			// This will complete if no args are passed
			if len(c.Args()) > 0 {
				return
			}
			for _, t := range tasks {
				fmt.Println(t)
			}
		},
	},
}

// CmdNotFound outputs a formatted command not found message
func CmdNotFound(c *cli.Context, command string) {
	log.Fatalf("%s: '%s' is not a %s command. See '%s --help'.", c.App.Name, command, c.App.Name, os.Args[0])
}
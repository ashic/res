﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Common.Logging;
using NetMQ.zmq;
using SimpleConfig;
using Topshelf;
using Topshelf.Common.Logging;

namespace Res
{
    class Program
    {
        private static readonly ILog Logger = LogManager.GetCurrentClassLogger();
        static void Main(string[] args)
        {
            HostFactory.Run(x =>
            {
                string endpoint = null;

                x.AddCommandLineDefinition("endpoint", s => endpoint = s);
                x.ApplyCommandLine();

                x.Service<ResHost>(s =>
                {
                    var config = Configuration.Load<ResConfiguration>();

                    if (string.IsNullOrWhiteSpace(endpoint) == false)
                    {
                        Console.WriteLine("setting endpoint...");
                        config.TcpEndpoint = endpoint;
                    }

                    s.ConstructUsing(name => new ResHost());
                    s.WhenStarted(rh => rh.Start(config));
                    s.WhenStopped(rh => rh.Stop());
                });

                x.RunAsLocalSystem();

                x.SetDescription("Res");
                x.SetDisplayName("Res");
                x.SetServiceName("Res");

                x.UseCommonLogging();
            });
        }
    }
}

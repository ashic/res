using System;

namespace Res.Core.Tests.Storage
{
    public class EventStorageException : Exception
    {
        public EventStorageException(string message, Exception innerException)
            : base(message, innerException)
        {
        }

        public EventStorageException(Exception innerException)
            : this(null, innerException)
        {
        }
    }
}
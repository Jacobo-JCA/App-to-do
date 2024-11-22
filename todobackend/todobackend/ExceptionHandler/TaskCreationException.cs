namespace todobackend.ExceptionHandler
{
    [Serializable]
    internal class TaskCreationException : Exception
    {
        public TaskCreationException()
        {
        }

        public TaskCreationException(string? message) : base(message)
        {
        }

        public TaskCreationException(string? message, Exception? innerException) : base(message, innerException)
        {
        }
    }
}
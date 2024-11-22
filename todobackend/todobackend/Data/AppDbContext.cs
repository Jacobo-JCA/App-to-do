using Microsoft.EntityFrameworkCore;
using todobackend.Models;

namespace todobackend.Data
{
    public class AppDbContext : DbContext
    {
        public DbSet<TaskModel> Tasks { get; set; }

        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        { }
    }
}
